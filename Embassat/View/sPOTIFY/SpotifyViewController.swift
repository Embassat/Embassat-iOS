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
import SwiftyJSON

final class SpotifyViewController: RootViewController, UpdateableView, SPTAudioStreamingDelegate, UICollectionViewDelegate, ViewModelCollectionDelegate {
    
    var artists: [[String:Any]] = []
    
    lazy var player: SPTAudioStreamingController = {
        let player = SPTAudioStreamingController.sharedInstance()!
        player.delegate = self
        
        return player
    }()
    
    fileprivate var dataSource: ArrayDataSource?
    let tracksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 53)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
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
            guard isViewLoaded else { return }
            
//            updateSubviews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        updateDataSource()

        do {
            try player.start(withClientId: viewModel.clientId)
        } catch {
            print(error)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startAuthFlow()
    }
    
    func handleAuthCallback() {
        dismiss(animated: true)
        player.login(withAccessToken: viewModel.accessToken)
    }
    
    // MARK: - SPTAudioStreamingDelegate
    
    func startAuthFlow() {
        if viewModel.isSessionValid {
            player.login(withAccessToken: viewModel.accessToken)
        } else {
            let authViewController = SFSafariViewController(url: viewModel.authURL)
            present(authViewController, animated: true)
        }
    }
    
    private func setupView() {
        view.addSubview(tracksCollectionView)
        NSLayoutConstraint.useAndActivate([
            tracksCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tracksCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tracksCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tracksCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor)])
        view.backgroundColor = .secondary
        tracksCollectionView.backgroundColor = .clear
        tracksCollectionView.delegate = self
        tracksCollectionView.register(SpotifyTrackCollectionViewCell.self, forCellWithReuseIdentifier: ArrayDataSource.CADCellIdentifier)
    }
    
    fileprivate func updateDataSource() {
        dataSource =
            ArrayDataSource(
                viewModel: self,
                configureCellBlock: { [weak self] (cell, indexPath) in
                    guard let strongSelf = self else { return }
                    
                    let theCell = cell as! SpotifyTrackCollectionViewCell
                    let artist = strongSelf.artists[indexPath.row]
                    theCell.titleLabel.text = "\(artist["name"]!) - \(artist["artist"]!)"
                    
                },
                configureHeaderBlock: nil
        )
        tracksCollectionView.dataSource = dataSource
        tracksCollectionView.reloadData()
    }
    
    internal func numberOfItemsInSection(_ section: Int) -> Int {
        return artists.count
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let uri = artists[indexPath.row]["uri"]
        player.playSpotifyURI(uri as! String!, startingWith: 0, startingWithPosition: 0) { (error) in
            
        }
    }
    
    
    // MARK: - SPTAudioStreamingDelegate
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        let request = try! SPTRequest.createRequest(
            for: URL(string: "https://api.spotify.com/v1/users/embassat/playlists/7HFjIyFcpxDfl4GMnoms0v/tracks")!,
            withAccessToken: viewModel.accessToken,
            httpMethod: "GET",
            values: [],
            valueBodyIsJSON: false,
            sendDataAsQueryString: true
        )
        
        SPTRequest.sharedHandler().perform(request) { (error, response, data) in
            if error == nil {
                let bar = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                let foo = bar["items"] as! [[String:Any]]
                
                for (_,subJson):(String, JSON) in JSON(foo) {
                    let images = subJson["track"]["album"]["images"]
                    self.artists.append(["name" : subJson["track"]["name"].stringValue,
                                         "artist" : subJson["track"]["artists"][0]["name"].stringValue,
                                         "uri" : subJson["track"]["uri"].stringValue,
                                         "imageURL" : images[0]["url"].stringValue])
                }
                
                self.updateDataSource()
                self.tracksCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
                self.collectionView(self.tracksCollectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
            }
                    
        }
    }

}
