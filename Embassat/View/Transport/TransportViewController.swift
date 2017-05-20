//
//  TransportViewController.swift
//  Embassat
//
//  Created by Joan Romano on 30/04/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import UIKit

class TransportViewController: EmbassatRootViewController {

    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var detailLabel: UILabel?
    
    init() {
        super.init(nibName: String(describing: TransportViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Transport"
        
        titleLabel?.font = UIFont.detailFont(ofSize: 20)
        detailLabel?.font = UIFont.detailFont(ofSize: 15)
    }
    
}
