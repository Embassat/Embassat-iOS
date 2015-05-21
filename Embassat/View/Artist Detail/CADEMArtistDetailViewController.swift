//
//  CADEMArtistDetailViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 17/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

public class CADEMArtistDetailViewController: CADEMRootViewControllerSwift {
    
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var coverImage: UIImageView?
    @IBOutlet weak var infoView: UIView?
    @IBOutlet weak var bottomView: UIView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var artistNameLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var dayLabel: UILabel?
    @IBOutlet weak var timeLabel: UILabel?
    @IBOutlet weak var stageLabel: UILabel?
    
    public var viewModel: CADEMArtistDetailViewModel? {
        didSet {
            self.updateSubviewDetails()
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Artista"
        descriptionLabel?.font = UIFont.em_detailFontOfSize(15.0)
        stageLabel?.font = UIFont.em_detailFontOfSize(15.0)
        dayLabel?.font = UIFont.em_detailFontOfSize(15.0)
        timeLabel?.font = UIFont.em_detailFontOfSize(15.0)
        view.backgroundColor = UIColor.whiteColor()
        
        let shareItem = UIBarButtonItem(image: UIImage(named: "share.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "sharePressed")
        let favItem = UIBarButtonItem(image: UIImage(named: "fav.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "favoritePressed")
        
        self.navigationItem.rightBarButtonItems = [favItem, shareItem]
    }
    
    @IBAction func nextPressed(sender: UIButton) {
        viewModel?.currentIndex++
        self.updateSubviewDetails()
    }
    
    @IBAction func previousPressed(sender: UIButton) {
        viewModel?.currentIndex--
        self.updateSubviewDetails()
    }
    
    func updateSubviewDetails() {
        artistNameLabel?.text = viewModel?.artistName
        coverImage?.sd_setImageWithURL(viewModel?.artistImageURL, placeholderImage: UIImage(named: "loading.jpg"))
        stageLabel?.text = viewModel?.artistStage
        dayLabel?.text = viewModel?.artistDay
        
        viewModel?.artistDescriptionSignal?.subscribeNext({ [unowned self] (description: AnyObject!) -> Void in
            let descriptionText: String = description as! String
            self.descriptionLabel?.text = descriptionText
            self.activityIndicator?.stopAnimating()
            })
    }
    
    func sharePressed() {
        viewModel?.shareAction(forViewController: self)
    }
    
    func favoritePressed() {
        viewModel?.addEventOnCalendar()
    }
}
