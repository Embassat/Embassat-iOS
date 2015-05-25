//
//  CADEMInfoViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 24/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

public class CADEMInfoViewController: CADEMRootViewController {
    
    @IBOutlet weak var infoCollectionView: UICollectionView?
    let prototypeCell: CADEMInfoCollectionViewCell
    let dataSource: CADArrayDataSource
    let viewModel: CADEMInfoViewModel
    
    override init(nibName nibNameOrNil: String?, bundle nibBundle: NSBundle?) {
        
        let theViewModel = CADEMInfoViewModel()
        prototypeCell = UINib(nibName: "CADEMInfoCollectionViewCell", bundle: nil).instantiateWithOwner(nil, options: nil).first as! CADEMInfoCollectionViewCell
        dataSource =
            CADArrayDataSource(viewModel: theViewModel,
                configureCellBlock: { (cell: AnyObject!, indexPath: NSIndexPath) -> Void in
                    let theCell = cell as! CADEMInfoCollectionViewCell
            
                    theCell.body = theViewModel.bodyAtIndexPath(indexPath)
                },
                configureHeaderBlock: { (header: AnyObject!, indexPath: NSIndexPath) -> Void in
                    let theHeader = header as! CADEMInfoHeaderView
                
                    theHeader.title = theViewModel.titleAtIndexPath(indexPath)
                    theHeader.cover = theViewModel.imageAtIndexPath(indexPath)
            })
        viewModel = theViewModel
        
        super.init(nibName: nibNameOrNil, bundle: nibBundle)
    }
    
    required public convenience init(coder aDecoder: NSCoder) {
        self.init(nibName: nil, bundle: nil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Info"
        
        infoCollectionView?.dataSource = dataSource
        infoCollectionView?.registerNib(UINib(nibName: "CADEMInfoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CADArrayDataSource.CADCellIdentifier)
        infoCollectionView?.registerNib(UINib(nibName: "CADEMInfoHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CADArrayDataSource.CADHeaderIdentifier)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        prototypeCell.body = viewModel.bodyAtIndexPath(indexPath)
        
        return prototypeCell.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
    }
}
