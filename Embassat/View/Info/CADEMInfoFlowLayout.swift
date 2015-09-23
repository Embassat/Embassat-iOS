//
//  CADEMInfoFlowLayout.swift
//  Embassa't
//
//  Created by Joan Romano on 24/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

public class CADEMInfoFlowLayout: UICollectionViewFlowLayout {
    
    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard var answer = super.layoutAttributesForElementsInRect(rect) else {
            return []
        }
        
        let cv = self.collectionView
        let contentOffset = cv?.contentOffset
        let missingSections = NSMutableIndexSet()
        
        for layoutAttributes: UICollectionViewLayoutAttributes in answer {
            if layoutAttributes.representedElementCategory == UICollectionElementCategory.Cell {
                missingSections.addIndex(layoutAttributes.indexPath.section)
            }
        }
        
        for layoutAttributes: UICollectionViewLayoutAttributes in answer {
            if let elemendKind = layoutAttributes.representedElementKind {
                if elemendKind == UICollectionElementKindSectionHeader {
                    missingSections.removeIndex(layoutAttributes.indexPath.section)
                }
            }
        }
        
        missingSections.enumerateIndexesUsingBlock { (idx: Int, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            let indexPath = NSIndexPath(forItem: 0, inSection: idx)
            if let layouAttributes = self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: indexPath) {
                answer.append(layouAttributes)
            }
        }
        
        for layoutAttributes: UICollectionViewLayoutAttributes in answer {
            if let elemendKind = layoutAttributes.representedElementKind {
                if elemendKind == UICollectionElementKindSectionHeader {
                    
                    let section = layoutAttributes.indexPath.section
                    let numberOfItemsInSection = cv?.numberOfItemsInSection(section)
                    
                    if numberOfItemsInSection > 0 {
                        let firstCellIndexPath = NSIndexPath(forItem: 0, inSection: section)
                        let lastCellIndexPath = NSIndexPath(forItem: max(0, numberOfItemsInSection! - 1), inSection: section)
                        
                        if  let firstCellAttrs = self.layoutAttributesForItemAtIndexPath(firstCellIndexPath),
                            let lastCellAttrs = self.layoutAttributesForItemAtIndexPath(lastCellIndexPath) {
                                let headerHeight = CGRectGetHeight(layoutAttributes.frame)
                                var origin = layoutAttributes.frame.origin
                                origin.y = min(
                                    max(
                                        contentOffset!.y /*- 175.0f*/ + 64.0,
                                        (CGRectGetMinY(firstCellAttrs.frame) - headerHeight)
                                    ),
                                    (CGRectGetMaxY(lastCellAttrs.frame) - headerHeight)
                                );
                                layoutAttributes.zIndex = 1024;
                                layoutAttributes.frame = CGRectMake(origin.x, origin.y, layoutAttributes.frame.size.width, layoutAttributes.frame.size.height)
       
                        }
                    }
                    
                }
            }
        }
        
        return answer
    }

    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
}