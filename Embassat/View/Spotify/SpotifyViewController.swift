//
//  SpotifyViewController.swift
//  Embassat
//
//  Created by Joan Romano on 28/5/17.
//  Copyright © 2017 Crows And Dogs. All rights reserved.
//

import UIKit
import SafariServices
import Spotify

final class SpotifyViewController: RootViewController, UpdateableView {
    
    private lazy var player: SPTAudioStreamingController = {
        let player = SPTAudioStreamingController.sharedInstance()!
        player.delegate = self
        player.playbackDelegate = self
        
        return player
    }()
    
    fileprivate var dataSource: ArrayDataSource?
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.color = .primary
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    fileprivate lazy var tracksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 53)
        layout.minimumLineSpacing = 0
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle(String.loginWithSpotifyTitle, for: .normal)
        button.titleLabel?.font = .detailFont(ofSize: 15.0)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.backgroundColor = .spotify
        button.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Navigation items
    
    private lazy var titleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.titleFont(ofSize: 15)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.addTarget(self, action: #selector(titlePressed), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var playButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(togglePlay))
        
        return button
    }()
    
    private lazy var pauseButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(togglePlay))
        
        return button
    }()
    
    fileprivate var lastDuration: TimeInterval = 0
    
    fileprivate lazy var progressView: SpotifyProgressView = {
        let view = SpotifyProgressView(frame: CGRect(origin: .zero, size: CGSize(width: 45, height: 45)))
        view.isHidden = true
        
        return view
    }()
    
    // MARK: - Public
    
    public init(viewModel: SpotifyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = String.spotifyTitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel: SpotifyViewModel {
        didSet {
            guard isViewLoaded, viewModel.shouldShowContent else { return }
            
            updateContent()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        updateDataSource()

        do {
            try player.start(withClientId: viewModel.clientId)
            startAuthFlow()
        } catch {
            print(error)
        }
    }
    
    func handleAuthCallback() {
        dismiss(animated: true)
        player.login(withAccessToken: viewModel.accessToken)
        showContent(true)
    }
    
    // MARK: - Private
    
    private func startAuthFlow() {
        if viewModel.isSessionValid {
            showContent(true)
            player.login(withAccessToken: viewModel.accessToken)
        } else {
            showContent(false)
        }
    }
    
    private func showContent(_ shouldShow: Bool) {
        shouldShow ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        loginButton.isHidden = shouldShow
        tracksCollectionView.isHidden = !shouldShow
    }
    
    private func updateContent() {
        updateDataSource()
        showContent(true)
        activityIndicator.stopAnimating()
    }
    
    private func setupView() {
        view.backgroundColor = .secondary
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: progressView)
        titleButton.setTitle(String.spotifyTitle, for: .normal)
        tracksCollectionView.backgroundColor = .clear
        tracksCollectionView.delegate = self
        tracksCollectionView.register(SpotifyTrackCollectionViewCell.self, forCellWithReuseIdentifier: ArrayDataSource.CADCellIdentifier)
        
        [tracksCollectionView, loginButton, activityIndicator].forEach(view.addSubview)
        
        NSLayoutConstraint.useAndActivate([
            tracksCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tracksCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tracksCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tracksCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }
    
    private func updateDataSource() {
        dataSource =
            ArrayDataSource(
                viewModel: viewModel,
                configureCellBlock: { [weak self] (cell, indexPath) in
                    guard let strongSelf = self else { return }
                    
                    let theCell = cell as! SpotifyTrackCollectionViewCell
                    
                    theCell.trackName = strongSelf.viewModel.titleAtIndexPath(indexPath)
                    theCell.hidesBottomSeparator = strongSelf.viewModel.shouldHideSeparator(forIndexPath: indexPath)
                },
                configureHeaderBlock: nil
        )
        tracksCollectionView.dataSource = dataSource
        tracksCollectionView.reloadData()
    }
    
    fileprivate func playTrack(atIndex indexPath: IndexPath, shouldSelect: Bool = true) {
        guard titleButton.title(for: .normal) != viewModel.titleAtIndexPath(indexPath) else { return }
        
        navigationItem.titleView = titleButton
        titleButton.setTitle(viewModel.titleAtIndexPath(indexPath), for: .normal)
        titleButton.sizeToFit()
        player.playSpotifyURI(viewModel.playableURIAtIndexPath(indexPath),
                              startingWith: 0,
                              startingWithPosition: 0) { [weak self] (error) in
            self?.progressView.isHidden = false
            self?.navigationItem.leftBarButtonItem = self?.pauseButton
        }
        
        if shouldSelect {
            tracksCollectionView.selectItem(at: indexPath,
                                            animated: true,
                                            scrollPosition: .centeredVertically)
        }
    }
    
    @objc private func loginPressed() {
        let authViewController = SFSafariViewController(url: viewModel.authURL)
        present(authViewController, animated: true)
    }
    
    @objc private func togglePlay() {
        guard let leftItem = navigationItem.leftBarButtonItem else { return }
        
        let isPlaying = leftItem == playButton
        
        player.setIsPlaying(isPlaying) { [weak self] (_) in
            self?.navigationItem.leftBarButtonItem = isPlaying ? self?.pauseButton : self?.playButton
        }
    }
    
    @objc private func titlePressed() {
        guard let selectedIndexPath = tracksCollectionView.indexPathsForSelectedItems?.first else { return }
        
        tracksCollectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .centeredVertically)
    }
}

extension SpotifyViewController: SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    
    // MARK: - SPTAudioStreamingPlaybackDelegate
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePosition position: TimeInterval) {
        progressView.setProgress(CGFloat(position/lastDuration))
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChange metadata: SPTPlaybackMetadata!) {
        lastDuration = metadata.currentTrack?.duration ?? 0
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStopPlayingTrack trackUri: String!) {
        guard let indexPath = tracksCollectionView.indexPathsForSelectedItems?.first,
            viewModel.shouldPlayNextSong(forIndexPath: indexPath) else { return }
        
        playTrack(atIndex: IndexPath(item: indexPath.item + 1, section: indexPath.section))
    }
    
    // MARK: - SPTAudioStreamingDelegate
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        viewModel.fetchTracks()
    }
}

extension SpotifyViewController: UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        playTrack(atIndex: indexPath, shouldSelect: false)
    }
}
