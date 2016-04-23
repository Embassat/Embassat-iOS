//
//  MenuViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

public class MenuViewController: EmbassatRootViewController {
    
    @IBOutlet weak var menuCollectionView: UICollectionView?
    let dataSource: ArrayDataSource
    let viewModel: MenuViewModel
    
    override init(nibName nibNameOrNil: String?, bundle nibBundle: NSBundle?) {
        
        let theViewModel = MenuViewModel(model: ["Info", "Artistes", "Horaris", "Petit EM'", "Transport","Mapa", "Entrades"])
        dataSource =
            ArrayDataSource(viewModel: theViewModel,
                configureCellBlock: { (cell: AnyObject!, indexPath: NSIndexPath) -> Void in
                    let theCell = cell as! MenuCollectionViewCell
                    
                    theCell.optionName = theViewModel.titleAtIndexPath(indexPath)
                },
                configureHeaderBlock: nil)
        viewModel = theViewModel
        
        super.init(nibName: nibNameOrNil, bundle: nibBundle)
    }
    
    required public convenience init(coder aDecoder: NSCoder) {
        self.init(nibName: nil, bundle: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        menuCollectionView?.dataSource = dataSource
        menuCollectionView?.registerNib(UINib(nibName: String(MenuCollectionViewCell), bundle: nil), forCellWithReuseIdentifier: ArrayDataSource.CADCellIdentifier)
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
    }
    
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let indexPaths = menuCollectionView?.indexPathsForSelectedItems() {
            for indexPath in indexPaths {
                menuCollectionView?.deselectItemAtIndexPath(indexPath, animated: false)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var viewController: UIViewController?
        
        switch indexPath.item {
        case 0:
            viewController = InfoViewController(nibName: String(InfoViewController), bundle: nil)
            break;
            
        case 1:
            viewController = ArtistsViewController(nibName: String(ArtistsViewController), bundle: nil)
            break;
            
        case 2:
            viewController = ScheduleViewController(nibName: String(ScheduleViewController), bundle: nil)
            break;
            
        case 3:
            viewController = PetitEMViewController(nibName: String(PetitEMViewController), bundle: nil)
            break;
            
        case 4:
            viewController = InfoViewController(nibName: String(InfoViewController), bundle: nil)
            break;
            
        case 5:
            viewController = MapViewController(nibName: String(MapViewController), bundle: nil)
            break;
            
        case 6:
            viewController = TicketsViewController(nibName: String(TicketsViewController), bundle: nil)
            break;
            
        default:
            break;
        }
        
        if viewController != nil {
            navigationController?.pushViewController(viewController!, animated: true)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        return flowLayout.insetsForVerticallyCenteredSectionInScreen(withNumberOfRows: dataSource.viewModel.numberOfItemsInSection(0), andColumns: 1)
    }
    
}