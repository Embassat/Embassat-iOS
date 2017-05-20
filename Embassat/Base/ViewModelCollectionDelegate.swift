//
//  ViewModelCollectionDelegate.swift
//  Embassa't
//
//  Created by Joan Romano on 13/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

protocol ViewModelCollectionDelegate {
    func numberOfSections() -> Int
    func numberOfItemsInSection(_ section: Int) -> Int
}

extension ViewModelCollectionDelegate {
    func numberOfSections() -> Int {
        return 1
    }
}
