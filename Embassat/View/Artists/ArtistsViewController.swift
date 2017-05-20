//
//  ArtistsViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 16/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

class ArtistsViewController: EmbassatRootViewController, UpdateableView {
    
    @IBOutlet var artistsCollectionView: UICollectionView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    fileprivate var dataSource: ArrayDataSource?
    var viewModel: ArtistsViewModel {
        didSet {
            updateDataSource()
            activityIndicator?.stopAnimating()
        }
    }
    
    required init(viewModel: ArtistsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: ArtistsViewController.self), bundle: nil)
        self.updateDataSource()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Artistes"
        view.backgroundColor = .secondary
        artistsCollectionView.register(UINib(nibName: String(describing: ArtistCollectionViewCell.self), bundle: nil),
                                       forCellWithReuseIdentifier: ArrayDataSource.CADCellIdentifier)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        artistsCollectionView.deselectAllSelectedItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.shouldRefreshModel()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        viewModel.didSelect(at: indexPath.item)
    }
    
    fileprivate func updateDataSource() {
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
        artistsCollectionView.dataSource = dataSource
        artistsCollectionView.reloadData()
    }
}
