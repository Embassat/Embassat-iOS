//
//  TransportViewController.swift
//  Embassat
//
//  Created by Joan Romano on 30/04/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import UIKit

final class TransportViewController: RootViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    init() {
        super.init(nibName: String(describing: TransportViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = String.transportTitle
        
        view.backgroundColor = .secondary
        titleLabel.font = UIFont.detailFont(ofSize: 20)
        titleLabel.textColor = .primary
        detailLabel.font = UIFont.detailFont(ofSize: 15)
        detailLabel.textColor = .primary
    }
}

extension TransportViewController: Trackeable {
    var screen: Analytics.Screen { return .transport }
}
