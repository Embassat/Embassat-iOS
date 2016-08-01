//
//  ArtistsViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 16/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

class ArtistsViewController: EmbassatRootViewController, UpdateableView {
    
    @IBOutlet weak var artistsCollectionView: UICollectionView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    private var dataSource: ArrayDataSource?
    var viewModel: ArtistsViewModel {
        didSet {
            updateDataSource()
            activityIndicator?.stopAnimating()
        }
    }
    
    required init(viewModel: ArtistsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(ArtistsViewController), bundle: nil)
        self.updateDataSource()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Artistes"
        artistsCollectionView?.dataSource = dataSource
        artistsCollectionView?.registerNib(UINib(nibName: String(ArtistCollectionViewCell), bundle: nil), forCellWithReuseIdentifier: ArrayDataSource.CADCellIdentifier)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        artistsCollectionView?.deselectAllSelectedItems()
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        let artistDetailViewController = ArtistDetailViewController()
//        artistDetailViewController.viewModel = viewModel.artistViewModel(forIndexPath: indexPath)
//        artistDetailViewController.updateSignal.subscribeNext { [weak self] _ in
//            guard let weakSelf = self else { return }
//            
//            weakSelf.viewModel.shouldRefreshModel()
//        }
//        
//        self.navigationController?.pushViewController(artistDetailViewController, animated: true)
        viewModel.didSelect(at: indexPath.row)
    }
    
    private func updateDataSource() {
        dataSource =
            ArrayDataSource(
                viewModel: viewModel,
                configureCellBlock: { [weak self] (cell, indexPath) in
                    guard let strongSelf = self else { return }
                    
                    let theCell = cell as! ArtistCollectionViewCell
                    
                    theCell.optionName = strongSelf.viewModel.titleAtIndexPath(indexPath)
                    theCell.hidesBottomSeparator = indexPath.row == strongSelf.viewModel.numberOfItemsInSection(0) - 1
                },
                configureHeaderBlock: nil
            )
        artistsCollectionView?.dataSource = dataSource
        artistsCollectionView?.reloadData()
    }
}
