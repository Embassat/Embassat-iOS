//
//  CADEMInfoViewModel.swift
//  Embassa't
//
//  Created by Joan Romano on 24/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

public class CADEMInfoViewModel: NSObject, CADEMViewModelCollectionDelegateSwift {
    
    let titles: Array<String> = ["Què és l’Embassa't?", "Escenari Principal", "Amfiteatre", "Mirador Electrònic"]
    let bodies: Array<String> = [
    "L’EMBASSA’T és el teu festival. Et portem ben a prop els millors artistes d’aquí i d’allà, les bandes més potents de l’emergent panorama i els noms que trepitgen amb més ganes l’escena del moment.\n\nAmb tu volem continuar sent el motor perquè un cop més s’accelerin els fets, compartim els millors directes amb els teus amics en racons que mai els haguessis vist d’aquesta manera, i d’una forma única i privilegiada.\n\n3 escenaris de luxe. Un ventall musical envejable. Apte per tots: des del Petit Embassa’t,  els més tranquils, folks, pels que canten pop, criden punk o ballen rock, fins als que vulguin tancar les portes a ritme de hits més electrònics.\n\nAjuda’ns a fer-nos més sostenibles, tu també pots fer-nos millors i més grans. Suma’t a l’EMBASSA’T, El Festival Independent del Vallès. El festival que fa falta a Catalunya.",
    "Dins dels magnífics Jardins de l’Espai Cultura de la Fundació Sabadell 1859 pugen a l’escenari les propostes més fermes de l’escena del moment. Bandes que fa anys que criden un nom i un lloc, fins a grups més joves amb un insultant descaro, és aquí i ara on juguen les millors cartes. Sens dubte on es viu l’esclat del festival i on sempre podràs dir que hauràs vist els millors grups del demà.  Aforament 1.000 persones.",
    "Dins el recinte principal tenim la petita joia del festival. Les grades, la buguenvíl·lia, la llum, l’atmosfera que es palpa concert rere concert fan que des de les propostes més íntimes, al folk, cantautors, l’electrònica soft o més dura, al rock directe, garage o punk tinguin un contacte que mai abans hauràs viscut. Tota una experiència musical. Aforament amb butaca limitat 300 persones aproximadament.",
    "El Museu del Gas acull a dalt de tot del seu modern edifici un espai envejable, tan per les seves vistes com per la seva cuidada proposta. Una finestra oberta a la emergent electrònica barcelonina que ens acosta les sonoritats, bits i ritmes més contemporanis per contemplar el panorama que vindrà. Cinc hores diàries per submergir-nos en aquest fascinant univers. La cirereta més exclusiva del festival. Fins a completar aforament, 250 persones. "]
    
    func numberOfSections() -> Int {
        return 4
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
}

