//
//  CADArrayDataSource.swift
//  Embassa't
//
//  Created by Joan Romano on 13/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

typealias ConfigureViewBlock = (AnyObject, NSIndexPath) -> Void

public class CADArrayDataSource: NSObject, UICollectionViewDataSource {
    
    static let CADCellIdentifier : String = "CellIdentifier"
    static let CADHeaderIdentifier : String = "HeaderIdentifier"
    
    let viewModel: CADEMViewModelCollectionDelegate
    let configureCellBlock: ConfigureViewBlock
    let configureHeaderBlock: ConfigureViewBlock?
    
    init(viewModel : CADEMViewModelCollectionDelegate, configureCellBlock: ConfigureViewBlock, configureHeaderBlock: ConfigureViewBlock?) {
        self.viewModel = viewModel
        self.configureCellBlock = configureCellBlock
        self.configureHeaderBlock = configureHeaderBlock
    }
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        if let viewModel = self.viewModel as? NSObject {
            if viewModel.respondsToSelector("numberOfSections") {
                return self.viewModel.numberOfSections!()
            } else {
                return 1
            }
        } else {
            return 1
        }
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfItemsInSection(section)
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: AnyObject = collectionView.dequeueReusableCellWithReuseIdentifier(CADArrayDataSource.CADCellIdentifier, forIndexPath: indexPath)
        self.configureCellBlock(cell, indexPath)
        
        return cell as! UICollectionViewCell
    }
    
    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let view: AnyObject = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: CADArrayDataSource.CADHeaderIdentifier, forIndexPath: indexPath)
        if let configureBlock  = self.configureHeaderBlock {
            configureBlock(view, indexPath)
        }
        
        return view as! UICollectionReusableView
    }
}
