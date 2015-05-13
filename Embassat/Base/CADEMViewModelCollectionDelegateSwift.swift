//
//  CADEMViewModelCollectionDelegateSwift.swift
//  Embassa't
//
//  Created by Joan Romano on 13/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

@objc protocol CADEMViewModelCollectionDelegateSwift {
    
    optional func numberOfSections() -> Int
    func numberOfItemsInSection(section: Int) -> Int
}
