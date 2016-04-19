//
//  CADEMArtistDetailViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 17/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit
import ReactiveCocoa
import WebImage

public class CADEMArtistDetailViewController: CADEMRootViewController {
    
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var coverImage: UIImageView?
    @IBOutlet weak var infoView: UIView?
    @IBOutlet weak var bottomView: UIView?
    @IBOutlet weak var artistNameLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var dayLabel: UILabel?
    @IBOutlet weak var timeLabel: UILabel?
    @IBOutlet weak var stageLabel: UILabel?
    
    public var updateSignal: RACSubject = RACSubject()
    public var viewModel: CADEMArtistDetailViewModel? {
        didSet {
            self.updateSubviewDetails()
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Artista"
        artistNameLabel?.font = UIFont.detailFont(ofSize: 20.0)
        descriptionLabel?.font = UIFont.detailFont(ofSize: 15.0)
        stageLabel?.font = UIFont.detailFont(ofSize: 15.0)
        dayLabel?.font = UIFont.detailFont(ofSize: 15.0)
        timeLabel?.font = UIFont.detailFont(ofSize: 15.0)
        
        let shareItem = UIBarButtonItem(image: UIImage(named: "share.png"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CADEMArtistDetailViewController.sharePressed))
        let favItem = UIBarButtonItem(image: UIImage(named: "fav.png"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CADEMArtistDetailViewController.favoritePressed))
        
        self.navigationItem.rightBarButtonItems = [favItem, shareItem]
    }
    
    @IBAction func nextPressed(sender: UIButton) {
        viewModel?.currentIndex+=1
        self.updateSubviewDetails()
    }
    
    @IBAction func previousPressed(sender: UIButton) {
        viewModel?.currentIndex-=1
        self.updateSubviewDetails()
    }
    
    func updateSubviewDetails() {
        artistNameLabel?.text = viewModel?.artistName
        descriptionLabel?.text = viewModel?.artistDescription
        coverImage?.sd_setImageWithURL(viewModel?.artistImageURL, placeholderImage: UIImage(named: "loading.jpg"))
        stageLabel?.text = viewModel?.artistStage
        dayLabel?.text = viewModel?.artistDay
        timeLabel?.text = viewModel?.artistStartTimeString
        
        let favItem = self.navigationItem.rightBarButtonItems?.first
        favItem?.tintColor = viewModel?.artistIsFavorite == true ? UIColor.emBackgroundColor() : nil
    }
    
    func sharePressed() {
        viewModel?.shareAction(forViewController: self)
    }
    
    func favoritePressed() {
        viewModel?.toggleFavorite(){ [unowned self] () -> () in

            let favItem = self.navigationItem.rightBarButtonItems?.first
            favItem?.tintColor = favItem?.tintColor == nil ? UIColor.emBackgroundColor() : nil
            
            self.updateSignal.sendNext(true)
        }
    }
}
