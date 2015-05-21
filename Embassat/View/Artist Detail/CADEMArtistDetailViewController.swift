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
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var dayLabel: UILabel?
    @IBOutlet weak var timeLabel: UILabel?
    @IBOutlet weak var stageLabel: UILabel?
    @IBOutlet weak var shareButton: UIButton?
    @IBOutlet weak var addButton: UIButton?
    
    public var viewModel: CADEMArtistDetailViewModel? {
        didSet {
            title = viewModel?.artistName
            coverImage?.sd_setImageWithURL(viewModel?.artistImageURL, placeholderImage: UIImage(named: "loading.jpg"))
            stageLabel?.text = viewModel?.artistStage
            dayLabel?.text = viewModel?.artistDay
            
            viewModel?.artistDescriptionSignal.subscribeNext({ [unowned self] (description: AnyObject!) -> Void in
                let descriptionText: String = description as! String
                self.descriptionLabel?.text = descriptionText
                self.activityIndicator?.stopAnimating()
            })
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel?.font = UIFont.em_detailFontOfSize(15.0)
        stageLabel?.font = UIFont.em_detailFontOfSize(15.0)
        dayLabel?.font = UIFont.em_detailFontOfSize(15.0)
        timeLabel?.font = UIFont.em_detailFontOfSize(15.0)
        shareButton?.titleLabel?.font = UIFont.em_titleFontOfSize(16.0)
        addButton?.titleLabel?.font = UIFont.em_titleFontOfSize(16.0)
        view.backgroundColor = UIColor.whiteColor()
        
        shareButton?.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext({ [unowned self] (_) -> Void in
            viewModel?.shareAction(forViewController: self)
        })
        
        addButton?.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext({ (_) -> Void in
            viewModel?.addEventOnCalendar()
        })
    }
}
