//
//  MenuViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

class MenuViewController: EmbassatRootViewController, UpdateableView {
    
    @IBOutlet weak var menuCollectionView: UICollectionView?
    let dataSource: ArrayDataSource
    var viewModel: MenuViewModel {
        didSet {
            menuCollectionView?.reloadData()
        }
    }
    
    required init(viewModel: MenuViewModel) {
        dataSource =
            ArrayDataSource(viewModel: viewModel,
                            configureCellBlock: { cell, indexPath in
                                guard let cell = cell as? MenuCollectionViewCell else { return }
                                
                                cell.optionName = viewModel.titleAtIndexPath(indexPath)
                },
                            configureHeaderBlock: nil)
        self.viewModel = viewModel
        
        super.init(nibName: String(describing: MenuViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        menuCollectionView?.dataSource = dataSource
        menuCollectionView?.register(UINib(nibName: String(describing: MenuCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: ArrayDataSource.CADCellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let indexPaths = menuCollectionView?.indexPathsForSelectedItems {
            for indexPath in indexPaths {
                menuCollectionView?.deselectItem(at: indexPath, animated: false)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        viewModel.show(nextViewControllerWithIndex: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return UIEdgeInsets.zero }
        
        return flowLayout.insetsForVerticallyCenteredSectionInScreen(withNumberOfRows: dataSource.viewModel.numberOfItemsInSection(0), andColumns: 1)
    }
    
}
