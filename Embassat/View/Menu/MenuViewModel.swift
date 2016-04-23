//
//  MenuViewModel.swift
//  Embassa't
//
//  Created by Joan Romano on 13/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

public class MenuViewModel: NSObject, ViewModelCollectionDelegate {
    
    let model: [String]
    
    init(model : [String]) {
        self.model = model
    }
    
    func numberOfItemsInSection(section : Int) -> Int {
        return self.model.count
    }
    
    public func titleAtIndexPath(indexPath: NSIndexPath) -> String {
        return self.model[indexPath.row]
    }

}
