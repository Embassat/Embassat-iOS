//
//  CADEMArtistsViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 16/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

public class CADEMArtistsViewController: CADEMRootViewController {
    
    @IBOutlet weak var artistsCollectionView: UICollectionView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    let dataSource: CADArrayDataSource
    let viewModel: CADEMArtistsViewModel
    
    override init(nibName nibNameOrNil: String?, bundle nibBundle: NSBundle?) {

        let theViewModel = CADEMArtistsViewModel()
        dataSource = CADArrayDataSource(viewModel: theViewModel, configureCellBlock: { (cell: AnyObject!, indexPath: NSIndexPath) -> Void in
            let theCell = cell as! CADEMArtistCollectionViewCell
            
            theCell.optionName = theViewModel.titleAtIndexPath(indexPath)
            theCell.hidesBottomSeparator = indexPath.row == theViewModel.numberOfItemsInSection(0) - 1
        }, configureHeaderBlock: nil)
        viewModel = theViewModel
        
        super.init(nibName: nibNameOrNil, bundle: nibBundle)
    }

    required public convenience init(coder aDecoder: NSCoder) {
        self.init(nibName: nil, bundle: nil)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        title = "Artistes"
        artistsCollectionView?.dataSource = self.dataSource
        artistsCollectionView?.registerNib(UINib(nibName: "CADEMArtistCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CADArrayDataSource.CADCellIdentifier)
        
        if viewModel.numberOfItemsInSection(0) > 0 {
            self.activityIndicator?.stopAnimating()
        }
        
        viewModel.activeSubject.subscribeNext({ [unowned self] (_) -> Void in
            self.activityIndicator?.stopAnimating()
            self.artistsCollectionView?.reloadData()
        }, error: { (_) -> Void in
            self.activityIndicator?.stopAnimating()
            self.artistsCollectionView?.reloadData()
        })
    }
    
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let indexPaths = artistsCollectionView?.indexPathsForSelectedItems() {
            for indexPath in indexPaths {
                artistsCollectionView?.deselectItemAtIndexPath(indexPath, animated: false)
            }
        }
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let artistViewController = CADEMArtistDetailViewController(nibName: "CADEMArtistDetailViewController", bundle: nil)
        artistViewController.viewModel = viewModel.artistViewModel(forIndexPath: indexPath)
        artistViewController.updateSignal.subscribeNext { [unowned self] (_) -> Void in
            self.viewModel.shouldRefreshModel()
        }
        
        self.navigationController?.pushViewController(artistViewController, animated: true)
    }
}
