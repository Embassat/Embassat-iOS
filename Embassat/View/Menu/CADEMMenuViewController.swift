//
//  CADEMMenuViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation

public class CADEMMenuViewController: CADEMRootViewControllerSwift {
    
    @IBOutlet weak var menuCollectionView: UICollectionView?
    let dataSource: CADArrayDataSourceSwift
    let viewModel: CADEMMenuViewModel
    
    override init(nibName nibNameOrNil: String?, bundle nibBundle: NSBundle?) {
        
        let theViewModel = CADEMMenuViewModel(model: ["Info", "Artistes", "Horaris", "Mapa", "Entrades", "Extres"])
        dataSource =
            CADArrayDataSourceSwift(viewModel: theViewModel,
                configureCellBlock: { (cell: AnyObject!, indexPath: NSIndexPath) -> Void in
                    let theCell = cell as! CADEMMenuCollectionViewCell
                    
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
        menuCollectionView?.registerNib(UINib(nibName: "CADEMMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CADCellIdentifier)
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
    }
    
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let indexPaths = menuCollectionView?.indexPathsForSelectedItems() as? [NSIndexPath] {
            for indexPath in indexPaths {
                menuCollectionView?.deselectItemAtIndexPath(indexPath, animated: false)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var viewController: UIViewController?
        
        switch indexPath.item {
        case 0:
            viewController = CADEMInfoViewController(nibName: "CADEMInfoViewController", bundle: nil)
            break;
            
        case 1:
            viewController = CADEMArtistsViewController(nibName: "CADEMArtistsViewController", bundle: nil)
            break;
            
        case 2:
            viewController = CADEMScheduleViewController(nibName: "CADEMScheduleViewController", bundle: nil)
            break;
            
        case 3:
            viewController = CADEMMapViewController(nibName: "CADEMMapViewController", bundle: nil)
            break;
            
        case 4:
            viewController = CADEMTicketsViewController(nibName: "CADEMTicketsViewController", bundle: nil)
            break;
            
        case 5:
            viewController = CADEMExtrasViewController(nibName: "CADEMExtrasViewController", bundle: nil)
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
        
        return flowLayout.insetsForVerticallyCenteredSectionInScreenWithRows(dataSource.viewModel.numberOfItemsInSection(0), andColumns: dataSource.viewModel.numberOfSections!())
    }
    
}