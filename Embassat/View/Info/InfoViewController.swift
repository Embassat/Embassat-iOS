//
//  InfoViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 24/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

class InfoViewController: EmbassatRootViewController {
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var detailLabel: UILabel?
    
    init() {
        super.init(nibName: String(InfoViewController), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Info"
        
        titleLabel?.font = UIFont.detailFont(ofSize: 20)
        detailLabel?.font = UIFont.detailFont(ofSize: 15)
    }
}
