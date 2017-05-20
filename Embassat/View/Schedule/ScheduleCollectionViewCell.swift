//
//  ScheduleCollectionViewCell.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

class ScheduleCollectionViewCell: RootCollectionViewCell {
    
    @IBOutlet weak var startTimeLabel: UILabel?
    @IBOutlet weak var endTimeLabel: UILabel?
    @IBOutlet weak var artistNameLabel: UILabel?
    @IBOutlet weak var stageLabel: UILabel?
    @IBOutlet weak var favoriteImageView: UIImageView?
    
    var startTimeSting: String = "" {
        didSet {
            startTimeLabel?.text = startTimeSting
        }
    }
    
    var endTimeString: String = "" {
        didSet {
            endTimeLabel?.text = endTimeString
        }
    }
    
    var artistName: String = "" {
        didSet {
            artistNameLabel?.text = artistName
        }
    }
    
    var stageName: String = "" {
        didSet {
            stageLabel?.text = stageName
        }
    }
    
    var shouldShowFavorite: Bool = false {
        didSet {
            favoriteImageView?.isHidden = !shouldShowFavorite
        }
    }
    
    override func setupView() {
        super.setupView()
        
        startTimeLabel?.font = UIFont.detailFont(ofSize: 15.0)
        endTimeLabel?.font = UIFont.detailFont(ofSize: 15.0)
        artistNameLabel?.font = UIFont.detailFont(ofSize: 15.0)
        stageLabel?.font = UIFont.detailFont(ofSize: 15.0)
        artistNameLabel?.adjustsFontSizeToFitWidth = true
    }
}
