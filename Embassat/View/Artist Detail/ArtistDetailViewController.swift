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
        super.init(nibName: String(ArtistDetailViewController), bundle: nil)
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
        
        let shareItem = UIBarButtonItem(image: UIImage(named: "share.png"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(sharePressed))
        let favItem = UIBarButtonItem(image: UIImage(named: "fav.png"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(favoritePressed))
        
        navigationItem.rightBarButtonItems = [favItem, shareItem]
        
        updateSubviewDetails()
        updateNavigationItemDetails()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        contentView?.flashScrollIndicators()
    }
    
    private func updateSubviewDetails() {
        artistNameLabel?.text = viewModel.artistName
        descriptionLabel?.text = viewModel.artistDescription
        stageLabel?.text = viewModel.artistStage
        dayLabel?.text = viewModel.artistDay
        timeLabel?.text = viewModel.artistStartTimeString
        
        if viewModel.shouldShowArtistVideo() {
            imageView?.hidden = true
            playerView?.hidden = false
            playerView?.loadWithVideoId(viewModel.artistVideoId)
        } else {
            imageView?.hidden = false
            playerView?.hidden = true
            imageView?.sd_setImageWithURL(viewModel.artistImageURL, placeholderImage: UIImage(named: "loading.jpg"))
        }
    }
    
    private func updateNavigationItemDetails() {
        navigationItem.rightBarButtonItems?.first?.tintColor = viewModel.favTintColor()
    }
    
    @objc private func sharePressed() {
        viewModel.shareAction()
    }
    
    @objc private func favoritePressed() {
        viewModel.toggleFavorite()
    }
    
    @IBAction func nextPressed(sender: UIButton) {
        viewModel.showNext()
    }
    
    @IBAction func previousPressed(sender: UIButton) {
        viewModel.showPrevious()
    }
}
