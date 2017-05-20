//
//  UICollectionView+EMAdditions.swift
//  Embassat
//
//  Created by Joan Romano on 01/08/16.
//  Copyright © 2016 Crows And Dogs. All rights reserved.
//

import UIKit

extension UICollectionView {
    func deselectAllSelectedItems() {
        guard let indexPaths = indexPathsForSelectedItems else { return }
        
        for indexPath in indexPaths {
            deselectItem(at: indexPath, animated: false)
        }
    }
}
