//
//  ArtistsViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 16/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

final class ArtistsViewController: RootViewController, UpdateableView {
    
    @IBOutlet weak var artistsCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    fileprivate var dataSource: ArrayDataSource?
    var viewModel: ArtistsViewModel {
        didSet {
            guard isViewLoaded else { return }
            updateDataSource()
            activityIndicator.stopAnimating()
        }
    }
    
    required init(viewModel: ArtistsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: ArtistsViewController.self), bundle: nil)
        self.title = String.artistsTitle
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        updateDataSource()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        artistsCollectionView?.deselectAllSelectedItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.loadData()
    }
    
    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        viewModel.didSelect(at: indexPath.item)
    }
    
    // MARK: - Private
    
    fileprivate func setupSubviews() {
        view.backgroundColor = .secondary
        artistsCollectionView?.register(UINib(nibName: String(describing: ArtistCollectionViewCell.self), bundle: nil),
                                        forCellWithReuseIdentifier: ArrayDataSource.CADCellIdentifier)
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
