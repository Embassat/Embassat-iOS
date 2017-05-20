//
//  TicketsViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 14/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

final class TicketsViewController: RootViewController {
    
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet var bodyLabels: [UILabel]!
    @IBOutlet var detailScrollView: UIScrollView!
    @IBOutlet weak var seasonContainer: UIView!
    @IBOutlet weak var dayTicketContainer: UIView!
    @IBOutlet weak var petitEmTicketContainer: UIView!
    
    init() {
        super.init(nibName: String(describing: TicketsViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Entrades"
        
        view.backgroundColor = .secondary
        [seasonContainer, dayTicketContainer, petitEmTicketContainer].flatMap { $0 }.forEach {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(linkPressed))
            $0.addGestureRecognizer(tapGesture)
        }
        
        titleLabels.forEach { $0.font = UIFont.detailFont(ofSize: 20.0); $0.textColor = .primary }
        bodyLabels.forEach { $0.font = UIFont.detailFont(ofSize: 15.0); $0.textColor = .primary }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: bottomLayoutGuide.length, right: 0)
        detailScrollView.contentInset = insets
        detailScrollView.scrollIndicatorInsets = insets
    }
    
    @IBAction func linkPressed(_ sender: UIView) {
        openTicket(URL(string: "http://entradium.com/sites/MjQ0Mg==")!)
    }
    
    func openTicket(_ link: URL) {
        UIApplication.shared.openURL(link)
    }
}

