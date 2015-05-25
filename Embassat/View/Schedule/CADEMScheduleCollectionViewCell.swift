//
//  CADEMScheduleCollectionViewCell.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

public class CADEMScheduleCollectionViewCell: CADRootCollectionViewCell {
    
    @IBOutlet weak var startTimeLabel: UILabel?
    @IBOutlet weak var endTimeLabel: UILabel?
    @IBOutlet weak var artistNameLabel: UILabel?
    @IBOutlet weak var stageLabel: UILabel?
    @IBOutlet weak var favoriteImageView: UIImageView?
    
    public var startTimeSting: String = "" {
        didSet {
            startTimeLabel?.text = startTimeSting
        }
    }
    
    public var endTimeString: String = "" {
        didSet {
            endTimeLabel?.text = endTimeString
        }
    }
    
    public var artistName: String = "" {
        didSet {
            artistNameLabel?.text = artistName
        }
    }
    
    public var stageName: String = "" {
        didSet {
            stageLabel?.text = stageName
        }
    }
    
    public var shouldShowFavorite: Bool = false {
        didSet {
            favoriteImageView?.hidden = !shouldShowFavorite
        }
    }
    
    public override func setupView() {
        super.setupView()
        
        startTimeLabel?.font = UIFont.em_detailFontOfSize(15.0)
        endTimeLabel?.font = UIFont.em_detailFontOfSize(15.0)
        artistNameLabel?.font = UIFont.em_detailFontOfSize(15.0)
        stageLabel?.font = UIFont.em_detailFontOfSize(15.0)
        artistNameLabel?.adjustsFontSizeToFitWidth = true
    }
}
