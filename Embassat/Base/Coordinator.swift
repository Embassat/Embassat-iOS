//
//  Coordinator.swift
//  Embassat
//
//  Created by Joan Romano on 25/07/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import Foundation

protocol Coordinator {
    
}

protocol Interactor: class {
    associatedtype ModelType
    
    var model: ModelType { get }
    var updateHandler: ((ModelType) -> ())? { get set }
}

protocol UpdateableView: class {
    associatedtype ViewModelType: _ViewModel
    
    var viewModel: ViewModelType { get set }
    
    init(viewModel: ViewModelType)
}

protocol _ViewModel {
    associatedtype InteractorType: Interactor
    
    var interactor: InteractorType { get }
}

protocol ViewModel: _ViewModel {
    init(interactor: InteractorType)
}

protocol CoordinatedViewModel: _ViewModel {
    associatedtype CoordinatorType: Coordinator
    
    var coordinator: CoordinatorType { get }
    
    init(interactor: InteractorType, coordinator: CoordinatorType)
}

extension UpdateableView where ViewModelType: ViewModel {
    func bind(to interactor: ViewModelType.InteractorType) {
        interactor.updateHandler = { [weak self, weak interactor] model in
            guard let interactor = interactor, let view = self else { return }
            
            view.viewModel = ViewModelType(interactor: interactor)
        }
    }
}

extension UpdateableView where ViewModelType: CoordinatedViewModel {
    func bind(to interactor: ViewModelType.InteractorType) {
        interactor.updateHandler = { [weak self, weak interactor] model in
            guard let interactor = interactor, let view = self else { return }
            
            view.viewModel = ViewModelType(interactor: interactor, coordinator: view.viewModel.coordinator)
        }
    }
}
