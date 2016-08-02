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
        artistsCollectionView?.registerNib(UINib(nibName: String(ArtistCollectionViewCell), bundle: nil), forCellWithReuseIdentifier: ArrayDataSource.CADCellIdentifier)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        artistsCollectionView?.deselectAllSelectedItems()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.shouldRefreshModel()
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        viewModel.didSelect(at: indexPath.item)
    }
    
    private func updateDataSource() {
        dataSource =
            ArrayDataSource(
                viewModel: viewModel,
                configureCellBlock: { [weak self] (cell, indexPath) in
                    guard let strongSelf = self else { return }
                    
                    let theCell = cell as! ArtistCollectionViewCell
                    
                    theCell.optionName = strongSelf.viewModel.titleAtIndexPath(indexPath)
                    theCell.hidesBottomSeparator = strongSelf.viewModel.shouldHideSeparator(forIndexPath: indexPath)
                },
                configureHeaderBlock: nil
            )
        artistsCollectionView?.dataSource = dataSource
        artistsCollectionView?.reloadData()
    }
}
