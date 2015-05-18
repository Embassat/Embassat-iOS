//
//  CADEMArtistsViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 16/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

public class CADEMArtistsViewController: CADEMRootViewControllerSwift {
    
    @IBOutlet weak var artistsCollectionView: UICollectionView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    let dataSource: CADArrayDataSourceSwift
    let viewModel: CADEMArtistsViewModel
    
    override init(nibName nibNameOrNil: String?, bundle nibBundle: NSBundle?) {

        let theViewModel = CADEMArtistsViewModel()
        dataSource = CADArrayDataSourceSwift(viewModel: theViewModel, configureCellBlock: { (cell: AnyObject!, indexPath: NSIndexPath) -> Void in
            let theCell = cell as! CADEMMenuCollectionViewCell
            
            theCell.optionName = theViewModel.titleAtIndexPath(indexPath)
        }, configureHeaderBlock: nil)
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
        
        viewModel.activeSubject.subscribeNext({ [unowned self] (_) -> Void in
            self.activityIndicator?.stopAnimating()
            self.artistsCollectionView?.reloadData()
        }, error: { (_) -> Void in
            self.activityIndicator?.stopAnimating()
            self.artistsCollectionView?.reloadData()
        })
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let artistViewController = CADEMArtistDetailViewController(nibName: "CADEMArtistDetailViewController", bundle: nil)
        artistViewController.viewModel = viewModel.artistViewModel(forIndexPath: indexPath)
        
        self.navigationController?.pushViewController(artistViewController, animated: true)
    }
}
