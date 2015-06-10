//
//  CADEMInfoViewModel.swift
//  Embassa't
//
//  Created by Joan Romano on 24/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

public class CADEMInfoViewModel: NSObject, CADEMViewModelCollectionDelegate {
    
    let titles: Array<String> = ["Tant si plou com si fa sol", "Transport públic", "Escenaris"]
    let bodies: Array<String> = [
    "Canvi d’ubicació per garantir un esdeveniment sense risc de mullar-se i assegurar el millor cap de setmana possible. Nou espai principal, dos escenaris: exterior covert i teatre.\n\nNOU RECINTE: CA L’ESTRUCH\nCarrer de Sant Isidre,140\n08208 Sabadell, Barcelona",
    "Bus nocturn\n- Sabadell - Barcelona\n- Sabadell - Vallès - Barcelona\n\nFGC\n- Sabadell - Barcelona\n\nRODALIES R4\n- Sabadell - Barcelona",
    "Escenari Principal\nDins la nau industrial de Ca l’Estruch pugen les propostes més fermes de l’escena del moment. Sens dubte on es viu l’esclat del festival i on sempre podràs dir que hauràs vist els millors grups d’avui i demà. \n* Aforament limitat. \n\nEscenari Yeearphone\nEl teatre de l’Estruch ens posarà a tots de’n peus des de primera hora de la tarda fins ben entrada la nit. L’electrònica més íntima i ambiental, acústics propers o el garage i punk que donarà les gràcies a no tenir una platea, sinó una pista de ball. Una experiència musical per viure-la. \n* Aforament limitat 400 persones.\n\nMirador\nEl Museu del Gas de la Fundació Gas Natural Fenosa acull la jornada inagural del festival al mirador del seu modern edifici. Un espai envejable, tan per les seves vistes com per la seva cuidada proposta. Una finestra oberta a les noves bandes del Vallès, el surf més estiuenc o el primer guateque d’aquest gran cap de setmana.\n* Fins a completar aforament."]
    
    func numberOfSections() -> Int {
        return 3
    }
    
    func numberOfItemsInSection(section : Int) -> Int {
        return 1
    }
    
    public func titleAtIndexPath(indexPath: NSIndexPath) -> String {
        return titles[indexPath.section]
    }
    
    public func bodyAtIndexPath(indexPath: NSIndexPath) -> String {
        return bodies[indexPath.section]
    }
    
    public func imageAtIndexPath(indexPath: NSIndexPath) -> UIImage {
        return UIImage(named: String(format: "info%01d.jpg", indexPath.section + 1))!
    }
    
    public func linksAtIndexPath(indexPath: NSIndexPath) -> (Array<NSURL>, Array<NSRange>) {
        if indexPath.section == 1 {
            return ([NSURL(string: "http://www.atm.cat/web/ca/veure.php?pdf=ca/_dir_nocturn/N65.pdf&h=770")!, NSURL(string: "http://www.atm.cat/web/ca/veure.php?pdf=ca/_dir_nocturn/N61.pdf&h=770")!, NSURL(string: "http://www.fgc.cat/downloads/horaris/Sabadell_1403.pdf")!, NSURL(string: "http://rodalies.gencat.cat/web/.content/pdf/horaris/r4.pdf")!], [NSMakeRange(14, 21), NSMakeRange(37, 29), NSMakeRange(73, 21), NSMakeRange(110, 20)])
        } else {
            return ([], [])
        }
    }
}

