//
//  ArtistDetailViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 17/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit
import ReactiveCocoa
import youtube_ios_player_helper

class ArtistDetailViewController: EmbassatRootViewController {
    
    @IBOutlet weak var playerView: YTPlayerView?
    @IBOutlet weak var bottomView: UIView?
    @IBOutlet weak var contentView: UIScrollView?
    @IBOutlet weak var artistNameLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var dayLabel: UILabel?
    @IBOutlet weak var timeLabel: UILabel?
    @IBOutlet weak var stageLabel: UILabel?
    
    var updateSignal: RACSubject = RACSubject()
    var viewModel: ArtistDetailViewModel? {
        didSet {
            self.updateSubviewDetails()
        }
    }
    
    init() {
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
        
        let shareItem = UIBarButtonItem(image: UIImage(named: "share.png"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ArtistDetailViewController.sharePressed))
        let favItem = UIBarButtonItem(image: UIImage(named: "fav.png"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ArtistDetailViewController.favoritePressed))
        
        navigationItem.rightBarButtonItems = [favItem, shareItem]
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        contentView?.flashScrollIndicators()
    }
    
    @IBAction func nextPressed(sender: UIButton) {
        viewModel?.currentIndex+=1
        updateSubviewDetails()
    }
    
    @IBAction func previousPressed(sender: UIButton) {
        viewModel?.currentIndex-=1
        updateSubviewDetails()
    }
    
    func updateSubviewDetails() {
        artistNameLabel?.text = viewModel?.artistName
        descriptionLabel?.text = viewModel?.artistDescription
        stageLabel?.text = viewModel?.artistStage
        dayLabel?.text = viewModel?.artistDay
        timeLabel?.text = viewModel?.artistStartTimeString
        playerView?.loadWithVideoId("M7lc1UVf-VE")
        
        let favItem = navigationItem.rightBarButtonItems?.first
        favItem?.tintColor = viewModel?.artistIsFavorite == true ? .lightGrayColor() : .whiteColor()
    }
    
    func sharePressed() {
        viewModel?.shareAction(forViewController: self)
    }
    
    func favoritePressed() {
        viewModel?.toggleFavorite(){ [weak self] in
            guard let weakSelf = self else { return }

            let favItem = weakSelf.navigationItem.rightBarButtonItems?.first
            favItem?.tintColor = favItem?.tintColor == .whiteColor() ? .lightGrayColor() : .whiteColor()
            
            weakSelf.updateSignal.sendNext(true)
        }
    }
}
