//
//  ArrayDataSource.swift
//  Embassa't
//
//  Created by Joan Romano on 13/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

typealias ConfigureViewBlock = (AnyObject, IndexPath) -> Void

final class ArrayDataSource: NSObject, UICollectionViewDataSource {
    
    static let CADCellIdentifier : String = "CellIdentifier"
    static let CADHeaderIdentifier : String = "HeaderIdentifier"
    
    let viewModel: ViewModelCollectionDelegate
    let configureCellBlock: ConfigureViewBlock
    let configureHeaderBlock: ConfigureViewBlock?
    
    init(viewModel: ViewModelCollectionDelegate,
         configureCellBlock: @escaping ConfigureViewBlock,
         configureHeaderBlock: ConfigureViewBlock?) {
        self.viewModel = viewModel
        self.configureCellBlock = configureCellBlock
        self.configureHeaderBlock = configureHeaderBlock
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArrayDataSource.CADCellIdentifier, for: indexPath)
        configureCellBlock(cell, indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: ArrayDataSource.CADHeaderIdentifier,
                                                                   for: indexPath)
        configureHeaderBlock?(view, indexPath)
        
        return view
    }
}
