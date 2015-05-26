//
//  CADEMScheduleViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

public class CADEMScheduleViewController: CADEMRootViewController {
    
    @IBOutlet weak var scheduleCollectionView: UICollectionView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    let dataSource: CADArrayDataSource
    let viewModel: CADEMScheduleViewModel
    
    override init(nibName nibNameOrNil: String?, bundle nibBundle: NSBundle?) {
        
        let theViewModel = CADEMScheduleViewModel()
        dataSource = CADArrayDataSource(viewModel: theViewModel,
            configureCellBlock: { (cell: AnyObject!, indexPath: NSIndexPath) -> Void in
                let theCell = cell as! CADEMScheduleCollectionViewCell
            
                theCell.startTimeSting = theViewModel.initialTimeString(forIndexPath: indexPath)
                theCell.endTimeString = theViewModel.finalTimeString(forIndexPath: indexPath)
                theCell.artistName = theViewModel.artistName(forIndexPath: indexPath)
                theCell.stageName = theViewModel.stageName(forIndexPath: indexPath)
                theCell.shouldShowFavorite = theViewModel.favoritedStatus(forIndexPath: indexPath)
                theCell.backgroundColor = theViewModel.backgroundColor(forIndexPath: indexPath)
            },
            configureHeaderBlock: nil)
        viewModel = theViewModel
        
        super.init(nibName: nibNameOrNil, bundle: nibBundle)
    }
    
    required public convenience init(coder aDecoder: NSCoder) {
        self.init(nibName: nil, bundle: nil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Horaris"
        
        dataSource.configureHeaderBlock = { (header: AnyObject!, indexPath: NSIndexPath) -> Void in
            let theHeader = header as! CADEMScheduleHeaderView
            
            theHeader.daySelectedSignal.subscribeNext(
                { [unowned self] (index: AnyObject!) -> Void in
                    let index = index as! Int
                    self.viewModel.dayIndex = index
                    self.scheduleCollectionView?.reloadData()
            })
        }
        
        scheduleCollectionView?.dataSource = self.dataSource
        scheduleCollectionView?.registerNib(UINib(nibName: "CADEMScheduleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CADArrayDataSource.CADCellIdentifier)
        scheduleCollectionView?.registerNib(UINib(nibName: "CADEMScheduleHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: CADArrayDataSource.CADHeaderIdentifier)
        
        if viewModel.numberOfItemsInSection(0) > 0 {
            self.activityIndicator?.stopAnimating()
        }
        
        viewModel.activeSubject.subscribeNext({ [unowned self] (_) -> Void in
            self.activityIndicator?.stopAnimating()
            self.scheduleCollectionView?.reloadData()
        }, error: { (_) -> Void in
            self.activityIndicator?.stopAnimating()
            self.scheduleCollectionView?.reloadData()
        })
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let artistViewController = CADEMArtistDetailViewController(nibName: "CADEMArtistDetailViewController", bundle: nil)
        artistViewController.viewModel = viewModel.artistViewModel(forIndexPath: indexPath)
        artistViewController.updateSignal.subscribeNext { [unowned self] (_) -> Void in
            self.viewModel.shouldRefreshModel()
            self.scheduleCollectionView?.reloadData()
        }
        
        self.navigationController?.pushViewController(artistViewController, animated: true)
    }
}
