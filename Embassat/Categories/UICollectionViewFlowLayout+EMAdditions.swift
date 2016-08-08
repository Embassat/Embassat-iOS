//
//  UICollectionViewFlowLayout+EMAdditions.swift
//  Embassa't
//
//  Created by Joan Romano on 9/24/15.
//  Copyright © 2015 Crows And Dogs. All rights reserved.
//

import UIKit

extension UICollectionViewFlowLayout {

    func insetsForVerticallyCenteredSectionInScreen(withNumberOfRows numberOfRows: Int, andColumns numberOfColumns: Int) -> UIEdgeInsets {
        
        guard let theCollection = collectionView else {
            return UIEdgeInsetsZero
        }
        
        let totalHeight = CGRectGetHeight(theCollection.bounds) + theCollection.contentOffset.y
        let totalWidth = CGRectGetWidth(theCollection.bounds)
        let verticalInset = (totalHeight - (itemSize.height * CGFloat(numberOfRows) + minimumLineSpacing)) / 2.0
        let horizontalInset = (totalWidth - (itemSize.width * CGFloat(numberOfColumns) + minimumInteritemSpacing)) / 2.0
        
        return UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset);
    }
    
}
