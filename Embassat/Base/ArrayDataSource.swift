//
//  ArrayDataSource.swift
//  Embassa't
//
//  Created by Joan Romano on 13/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

typealias ConfigureViewBlock = (AnyObject, NSIndexPath) -> Void

class ArrayDataSource: NSObject, UICollectionViewDataSource {
    
    static let CADCellIdentifier : String = "CellIdentifier"
    static let CADHeaderIdentifier : String = "HeaderIdentifier"
    
    let viewModel: ViewModelCollectionDelegate
    let configureCellBlock: ConfigureViewBlock
    let configureHeaderBlock: ConfigureViewBlock?
    
    init(viewModel : ViewModelCollectionDelegate, configureCellBlock: ConfigureViewBlock, configureHeaderBlock: ConfigureViewBlock?) {
        self.viewModel = viewModel
        self.configureCellBlock = configureCellBlock
        self.configureHeaderBlock = configureHeaderBlock
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        if let viewModel = self.viewModel as? NSObject {
            if viewModel.respondsToSelector(#selector(ViewModelCollectionDelegate.numberOfSections)) {
                return self.viewModel.numberOfSections!()
            } else {
                return 1
            }
        } else {
            return 1
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfItemsInSection(section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: AnyObject = collectionView.dequeueReusableCellWithReuseIdentifier(ArrayDataSource.CADCellIdentifier, forIndexPath: indexPath)
        self.configureCellBlock(cell, indexPath)
        
        return cell as! UICollectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let view: AnyObject = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: ArrayDataSource.CADHeaderIdentifier, forIndexPath: indexPath)
        if let configureBlock  = self.configureHeaderBlock {
            configureBlock(view, indexPath)
        }
        
        return view as! UICollectionReusableView
    }
}
