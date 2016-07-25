//
//  MenuViewModel.swift
//  Embassa't
//
//  Created by Joan Romano on 13/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

class MenuViewModel: NSObject, ViewModelCollectionDelegate, CoordinatedViewModel {
    
    let interactor: MenuInteractor
    let coordinator: MenuCoordinator
    
    required init(interactor: MenuInteractor, coordinator: MenuCoordinator) {
        self.interactor = interactor
        self.coordinator = coordinator
    }
    
    func numberOfItemsInSection(section : Int) -> Int {
        return self.interactor.model.count
    }
    
    func titleAtIndexPath(indexPath: NSIndexPath) -> String {
        return self.interactor.model[indexPath.row]
    }
    
    func show(nextViewControllerWithIndex index: Int) {
        guard let menuIndex = MenuIndex(rawValue: index) else { fatalError("Invalid index to show from Menu") }
        
        coordinator.show(nextViewControllerWithIndex: menuIndex)
    }
}
