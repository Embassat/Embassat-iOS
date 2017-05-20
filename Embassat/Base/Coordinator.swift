//
//  Coordinator.swift
//  Embassat
//
//  Created by Joan Romano on 25/07/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import Foundation

/// An empty protocol for declaring Coordinators, which are responsible for setting up and present other calçots (e.g. segues, detail)
public protocol Coordinator: class {
    /* empty ATM */
}

/// A protocol for declaring Interactors, which are responsible for managing and updating the `Model` (i.e *CRUD* operations).
public protocol Interactor: class {
    /// The associated type of the model
    associatedtype ModelType
    
    /// The model
    var model: ModelType { get }
    
    /// A closure which gets executed when the model gets updated
    var modelDidUpdate: ((ModelType) -> Void)? { get set }
}

/// A protocol for declaring UpdateableViews, which are responsible for displaying data coming from the `ViewModel`and forwarding interactions to them.
public protocol UpdateableView: class {
    /// The associated type of the view model
    associatedtype ViewModelType
    
    /// The view model
    var viewModel: ViewModelType { get set }
    
    /// Initializes a new UpdateableView
    ///
    /// - parameter viewModel: The view model used by this UpdateableView
    ///
    /// - returns: A newly initialized UpdateableView instance
    init(viewModel: ViewModelType)
}

// MARK: Binding

public extension UpdateableView {
    
    /// Initializes a new UpdateableView providing an automatic binding
    ///
    /// - parameter interactor: The Interactor used by this UpdateableView's view model
    /// - parameter viewModelFactory: A escaping closure that initializes a new view model with a given Interactor and a model which matches the ModelType of the interactor
    ///
    /// - returns: A newly initialized UpdateableView instance
    init<InteractorType: Interactor>(binding interactor: InteractorType, viewModelFactory: @escaping (InteractorType, InteractorType.ModelType) -> ViewModelType) {
        self.init(viewModel: viewModelFactory(interactor, interactor.model))
        
        interactor.modelDidUpdate = { [weak self, weak interactor] (model) in
            guard let interactor = interactor, let view = self else {
                return
            }
            
            view.viewModel = viewModelFactory(interactor, model)
        }
    }
}
