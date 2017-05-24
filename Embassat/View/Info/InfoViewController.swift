//
//  InfoViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 24/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit
import TTTAttributedLabel

final class InfoViewController: RootViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailScrollView: UIScrollView!
    @IBOutlet var detailLabel: TTTAttributedLabel!
    
    init() {
        super.init(nibName: String(describing: InfoViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = String.infoTitle
        
        view.backgroundColor = .secondary
        titleLabel.font = UIFont.detailFont(ofSize: 20)
        titleLabel.textColor = .primary
        detailLabel.enabledTextCheckingTypes = NSTextCheckingResult.CheckingType.link.rawValue
        detailLabel.font = UIFont.detailFont(ofSize: 15)
        detailLabel.textColor = .primary
        
        detailLabel?.text = "Nou Embassa’ts. És diu ràpid, però aquesta novena edició va més enllà d’un nou cartell, nova gent, nova música, amb més ganes que mai, però amb la idea de sempre i esperant trobar-nos als de sempre. A aquells que feu possible el festival any rere any, pot sonar a tòpic… però és la veritat.\n\nCom també és cert que en tot el Vallès, no hi ha res… Sabadell abans i potser ara encara més necessita el de sempre: donar autèntic sentit a la paraula festival i vestir la nostra ciutat, encara que sigui per només unes hores, de música i alegria sense parar. Reivindicant espais, músics, maneres d’oci diferents, cultura i filosofia, un pensament positiu que vol encomanar el bon humor i la passió per la música des dels més petits als més grans. Intentant arribar al màxim de gent i estils possibles. Aquest any estem suant per no donar-vos excuses, veniu a l’Embassa’t."
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: bottomLayoutGuide.length, right: 0)
        detailScrollView.contentInset = insets
        detailScrollView.scrollIndicatorInsets = insets
    }
}
