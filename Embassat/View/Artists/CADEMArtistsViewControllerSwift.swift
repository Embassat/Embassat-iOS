//
//  CADEMArtistsViewControllerSwift.swift
//  Embassa't
//
//  Created by Joan Romano on 16/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

public class CADEMArtistsViewControllerSwift: CADEMRootViewControllerSwift {
    
    @IBOutlet weak var artistsCollectionView: UICollectionView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    let dataSource: CADArrayDataSource
    let viewModel: CADEMArtistsViewModel
    
    override init(nibName nibNameOrNil: String?, bundle nibBundle: NSBundle?) {

        let theViewModel = CADEMArtistsViewModel()
        dataSource = CADArrayDataSource(viewModel: theViewModel, configureCellBlock: { (cell: AnyObject!, indexPath: AnyObject!) -> Void in
            let theCell = cell as! CADEMMenuCollectionViewCell
            let theIndexPath = indexPath as! NSIndexPath
            
            theCell.optionName = theViewModel.titleAtIndexPath(theIndexPath)
            theCell.hidesTopSeparator = theIndexPath.row == 0
        })
        viewModel = theViewModel
        
        super.init(nibName: nibNameOrNil, bundle: nibBundle)
    }

    required public convenience init(coder aDecoder: NSCoder) {
        self.init(nibName: nil, bundle: nil)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        title = "ARTISTES"
        artistsCollectionView?.dataSource = self.dataSource
        artistsCollectionView?.registerNib(UINib(nibName: "CADEMMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CADArrayDataSourceSwift.CADCellIdentifier)
        
        self.viewModel.updatedContentSignal.subscribeNext { (_) -> Void in
            self.activityIndicator?.stopAnimating()
            self.artistsCollectionView?.reloadData()
        }
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.active = true
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
}
