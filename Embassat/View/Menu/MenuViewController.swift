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
        
        super.init(nibName: String(MenuViewController), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        menuCollectionView?.dataSource = dataSource
        menuCollectionView?.registerNib(UINib(nibName: String(MenuCollectionViewCell), bundle: nil), forCellWithReuseIdentifier: ArrayDataSource.CADCellIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let indexPaths = menuCollectionView?.indexPathsForSelectedItems() {
            for indexPath in indexPaths {
                menuCollectionView?.deselectItemAtIndexPath(indexPath, animated: false)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        viewModel.show(nextViewControllerWithIndex: indexPath.row)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return UIEdgeInsetsZero }
        
        return flowLayout.insetsForVerticallyCenteredSectionInScreen(withNumberOfRows: dataSource.viewModel.numberOfItemsInSection(0), andColumns: 1)
    }
    
}