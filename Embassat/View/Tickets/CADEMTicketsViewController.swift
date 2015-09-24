//
//  CADEMTicketsViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 14/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

public class CADEMTicketsViewController: CADEMRootViewController {
    
    @IBOutlet var titleLabels: [UILabel]?
    @IBOutlet var bodyLabels: [UILabel]?
    @IBOutlet weak var seasonContainer: UIView?
    @IBOutlet weak var dayTicketContainer: UIView?
    @IBOutlet weak var petitEmTicketContainer: UIView?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Entrades"
        
        for view in [seasonContainer, dayTicketContainer, petitEmTicketContainer] {
            let tapGesture = UITapGestureRecognizer()
            tapGesture.rac_gestureSignal()?.subscribeNext({ [unowned self] (_) -> Void in
                self.linkPressed(view!)
            })
            
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
        self.openTicket(NSURL(string: "https://www.ticketea.com/entrades-embassat-2015/")!)
    }
    
    func openTicket(link: NSURL) {
        UIApplication.sharedApplication().openURL(link)
    }
}

