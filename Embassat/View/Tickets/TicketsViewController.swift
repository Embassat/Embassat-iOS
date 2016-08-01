//
//  TicketsViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 14/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

class TicketsViewController: EmbassatRootViewController {
    
    @IBOutlet var titleLabels: [UILabel]?
    @IBOutlet var bodyLabels: [UILabel]?
    @IBOutlet weak var seasonContainer: UIView?
    @IBOutlet weak var dayTicketContainer: UIView?
    @IBOutlet weak var petitEmTicketContainer: UIView?
    
    init() {
        super.init(nibName: String(TicketsViewController), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Entrades"
        
        for view in [seasonContainer, dayTicketContainer, petitEmTicketContainer] {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(linkPressed))
            view?.addGestureRecognizer(tapGesture)
        }
        
        if let labels = titleLabels {
            for label in labels {
                label.font = UIFont.detailFont(ofSize: 20.0)
            }
        }
        
        if let labels = bodyLabels {
            for label in labels {
                label.font = UIFont.detailFont(ofSize: 15.0)
            }
        }
    }
    
    @IBAction func linkPressed(sender: UIView) {
        openTicket(NSURL(string: "http://entradium.com/sites/MjQ0Mg==")!)
    }
    
    func openTicket(link: NSURL) {
        UIApplication.sharedApplication().openURL(link)
    }
}

