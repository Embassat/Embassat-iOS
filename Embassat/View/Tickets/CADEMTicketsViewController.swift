//
//  CADEMTicketsViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 14/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

public class CADEMTicketsViewController: CADEMRootViewControllerSwift {
    
    @IBOutlet var titleLabels: [UILabel]?
    @IBOutlet var bodyLabels: [UILabel]?
    @IBOutlet weak var seasonContainer: UIView?
    @IBOutlet weak var dayTicketContainer: UIView?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Entrades"
        
        for view in [seasonContainer, dayTicketContainer] {
            let tapGesture = UITapGestureRecognizer()
            tapGesture.rac_gestureSignal()?.subscribeNext({ [unowned self] (_) -> Void in
                self.linkPressed(view!)
            })
            
            view?.addGestureRecognizer(tapGesture)
        }
        
        if let labels = titleLabels {
            for label in labels {
                label.font = UIFont.em_detailFontOfSize(20.0)
            }
        }
        
        if let labels = bodyLabels {
            for label in labels {
                label.font = UIFont.em_detailFontOfSize(15.0)
            }
        }
    }
    
    @IBAction func linkPressed(sender: UIView) {
        self.openTicket(NSURL(string: sender.tag == 3 ? "http://www.tresc.cat/fitxa/concerts/43054/Embassat-2014" : "https://www.ticketea.com/embassat-2014-festival-independent-del-valles/")!)
    }
    
    func openTicket(link: NSURL) {
        UIApplication.sharedApplication().openURL(link)
    }
}

