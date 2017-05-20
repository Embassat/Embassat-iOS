//
//  MenuViewModel.swift
//  Embassa't
//
//  Created by Joan Romano on 13/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

class MenuViewModel: ViewModelCollectionDelegate, CoordinatedViewModel {
    
    let interactor: MenuInteractor
    let coordinator: MenuCoordinator
    
    required init(interactor: MenuInteractor, coordinator: MenuCoordinator) {
        self.interactor = interactor
        self.coordinator = coordinator
    }
    
    func numberOfItemsInSection(_ section : Int) -> Int {
        return self.interactor.model.count
    }
    
    func titleAtIndexPath(_ indexPath: IndexPath) -> String {
        return self.interactor.model[indexPath.row]
    }
    
    func show(nextViewControllerWithIndex index: Int) {
        guard let menuIndex = MenuIndex(rawValue: index) else { fatalError("Invalid index to show from Menu") }
        
        coordinator.show(nextViewControllerWithIndex: menuIndex)
    }
}
