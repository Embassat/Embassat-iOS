//
//  ArtistsViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 16/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

public class ArtistsViewController: EmbassatRootViewController {
    
    @IBOutlet weak var artistsCollectionView: UICollectionView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    let dataSource: ArrayDataSource
    let viewModel: ArtistsViewModel
    
    override init(nibName nibNameOrNil: String?, bundle nibBundle: NSBundle?) {

        let theViewModel = ArtistsViewModel()
        dataSource = ArrayDataSource(viewModel: theViewModel, configureCellBlock: { (cell: AnyObject!, indexPath: NSIndexPath) -> Void in
            let theCell = cell as! ArtistCollectionViewCell
            
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
        artistsCollectionView?.dataSource = dataSource
        artistsCollectionView?.registerNib(UINib(nibName: String(ArtistCollectionViewCell), bundle: nil), forCellWithReuseIdentifier: ArrayDataSource.CADCellIdentifier)
        
        if viewModel.numberOfItemsInSection(0) > 0 {
            activityIndicator?.stopAnimating()
        }
        
        viewModel.activeSubject.subscribeNext({ [weak self] _ in
            guard let weakSelf = self else { return }
            
            weakSelf.activityIndicator?.stopAnimating()
            weakSelf.artistsCollectionView?.reloadData()
        }, error: { [weak self] _ in
            
            guard let weakSelf = self else { return }
            
            weakSelf.activityIndicator?.stopAnimating()
            weakSelf.artistsCollectionView?.reloadData()
        })
    }
    
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard let indexPaths = artistsCollectionView?.indexPathsForSelectedItems() else { return }
        
        for indexPath in indexPaths {
            artistsCollectionView?.deselectItemAtIndexPath(indexPath, animated: false)
        }
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let artistDetailViewController = ArtistDetailViewController(nibName: String(ArtistDetailViewController), bundle: nil)
        artistDetailViewController.viewModel = viewModel.artistViewModel(forIndexPath: indexPath)
        artistDetailViewController.updateSignal.subscribeNext { [unowned self] (_) -> Void in
            self.viewModel.shouldRefreshModel()
        }
        
        self.navigationController?.pushViewController(artistDetailViewController, animated: true)
    }
}
