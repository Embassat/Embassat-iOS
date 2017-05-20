//
//  ArtistDetailViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 17/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit
import SDWebImage
import youtube_ios_player_helper

class ArtistDetailViewController: EmbassatRootViewController, UpdateableView {
    
    @IBOutlet weak var playerView: YTPlayerView?
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var bottomView: UIView?
    @IBOutlet weak var contentView: UIScrollView?
    @IBOutlet weak var artistNameLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var dayLabel: UILabel?
    @IBOutlet weak var timeLabel: UILabel?
    @IBOutlet weak var stageLabel: UILabel?
    
    var viewModel: ArtistDetailViewModel<ArtistDetailCoordinator, ArtistDetailInteractor> {
        didSet {
            if oldValue.artistName != viewModel.artistName {
                updateSubviewDetails()
            }
            
            updateNavigationItemDetails()
        }
    }
    
    required init(viewModel: ArtistDetailViewModel<ArtistDetailCoordinator,ArtistDetailInteractor>) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: ArtistDetailViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Artista"
        artistNameLabel?.font = UIFont.titleFont(ofSize: 30.0)
        descriptionLabel?.font = UIFont.detailFont(ofSize: 15.0)
        stageLabel?.font = UIFont.detailFont(ofSize: 15.0)
        dayLabel?.font = UIFont.detailFont(ofSize: 15.0)
        timeLabel?.font = UIFont.detailFont(ofSize: 15.0)
        
        let shareItem = UIBarButtonItem(image: UIImage(named: "share.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(sharePressed))
        let favItem = UIBarButtonItem(image: UIImage(named: "fav.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(favoritePressed))
        
        navigationItem.rightBarButtonItems = [favItem, shareItem]
        
        updateSubviewDetails()
        updateNavigationItemDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        contentView?.flashScrollIndicators()
    }
    
    fileprivate func updateSubviewDetails() {
        artistNameLabel?.text = viewModel.artistName
        descriptionLabel?.text = viewModel.artistDescription
        stageLabel?.text = viewModel.artistStage
        dayLabel?.text = viewModel.artistDay
        timeLabel?.text = viewModel.artistStartTimeString
        
        if viewModel.shouldShowArtistVideo() {
            imageView?.isHidden = true
            playerView?.isHidden = false
            playerView?.load(withVideoId: viewModel.artistVideoId)
        } else {
            imageView?.isHidden = false
            playerView?.isHidden = true
            imageView?.sd_setImage(with: viewModel.artistImageURL, placeholderImage: UIImage(named: "loading.jpg"))
        }
    }
    
    fileprivate func updateNavigationItemDetails() {
        navigationItem.rightBarButtonItems?.first?.tintColor = viewModel.favTintColor()
    }
    
    @objc fileprivate func sharePressed() {
        viewModel.shareAction()
    }
    
    @objc fileprivate func favoritePressed() {
        viewModel.toggleFavorite()
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
        viewModel.showNext()
    }
    
    @IBAction func previousPressed(_ sender: UIButton) {
        viewModel.showPrevious()
    }
}
