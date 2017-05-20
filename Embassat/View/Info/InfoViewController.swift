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
        
        title = "Info"
        
        view.backgroundColor = .secondary
        titleLabel.font = UIFont.detailFont(ofSize: 20)
        titleLabel.textColor = .primary
        detailLabel.enabledTextCheckingTypes = NSTextCheckingResult.CheckingType.link.rawValue
        detailLabel.font = UIFont.detailFont(ofSize: 15)
        detailLabel.textColor = .primary
        
        detailLabel?.text = "La vuitena edició de l’Embassa’t no és només un pas més, després d’una llarga espera de 365 dies per molt que ens movem de lloc, a nosaltres ens continua movent el mateix que el primer dia: donar autèntic sentit a la paraula festival i vestir la nostra ciutat, encara que sigui per només  unes hores, de música  i alegria sense parar. Reivindicant espais, músics, maneres d’oci diferents, cultura i filosofia, un pensament positiu que vol encomanar el bon humor i la passió per la música des dels més petits als més grans. Intentant arribar al màxim de gent  i estils possibles. Des dels concerts principals a Can Marcet, la inauguració al Museu del Gas com els vermuts gratuïts al centre de Sabadell, no hi ha excusa per no fer Embassa't, aquesta és la qüestió.\n\nFem festival i fem molt més. Consulta la programació anual a www.embassat.com"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: bottomLayoutGuide.length, right: 0)
        detailScrollView.contentInset = insets
        detailScrollView.scrollIndicatorInsets = insets
    }
}
