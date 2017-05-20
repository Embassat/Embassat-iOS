//
//  ArrayDataSource.swift
//  Embassa't
//
//  Created by Joan Romano on 13/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

typealias ConfigureViewBlock = (AnyObject, IndexPath) -> Void

class ArrayDataSource: NSObject, UICollectionViewDataSource {
    
    static let CADCellIdentifier : String = "CellIdentifier"
    static let CADHeaderIdentifier : String = "HeaderIdentifier"
    
    let viewModel: ViewModelCollectionDelegate
    let configureCellBlock: ConfigureViewBlock
    let configureHeaderBlock: ConfigureViewBlock?
    
    init(viewModel: ViewModelCollectionDelegate, configureCellBlock: @escaping ConfigureViewBlock, configureHeaderBlock: ConfigureViewBlock?) {
        self.viewModel = viewModel
        self.configureCellBlock = configureCellBlock
        self.configureHeaderBlock = configureHeaderBlock
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AnyObject = collectionView.dequeueReusableCell(withReuseIdentifier: ArrayDataSource.CADCellIdentifier, for: indexPath)
        self.configureCellBlock(cell, indexPath)
        
        return cell as! UICollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view: AnyObject = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ArrayDataSource.CADHeaderIdentifier, for: indexPath)
        if let configureBlock  = self.configureHeaderBlock {
            configureBlock(view, indexPath)
        }
        
        return view as! UICollectionReusableView
    }
}
