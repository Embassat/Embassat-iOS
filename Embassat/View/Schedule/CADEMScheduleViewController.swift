//
//  CADEMScheduleViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

public class CADEMScheduleViewController: CADEMRootViewController {
    
    @IBOutlet weak var thursdayContainer: UIView?
    @IBOutlet weak var fridayContainer: UIView?
    @IBOutlet weak var saturdayContainer: UIView?
    @IBOutlet weak var thursdayLabel: UILabel?
    @IBOutlet weak var fridayLabel: UILabel?
    @IBOutlet weak var saturdayLabel: UILabel?
    
    @IBOutlet weak var scheduleCollectionView: UICollectionView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    let dataSource: CADArrayDataSource
    let viewModel: CADEMScheduleViewModel
    
    override init(nibName nibNameOrNil: String?, bundle nibBundle: NSBundle?) {
        
        let theViewModel = CADEMScheduleViewModel()
        dataSource = CADArrayDataSource(viewModel: theViewModel,
            configureCellBlock: { (cell: AnyObject!, indexPath: NSIndexPath) -> Void in
                let theCell = cell as! CADEMScheduleCollectionViewCell
            
                theCell.startTimeSting = theViewModel.startTimeString(forIndexPath: indexPath)
                theCell.endTimeString = theViewModel.endTimeString(forIndexPath: indexPath)
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
        
        thursdayLabel?.textColor = UIColor.whiteColor()
        thursdayContainer?.backgroundColor = UIColor.em_scheduleHeaderBackgroundColor()
        
        let containers: Array<UIView?> = [thursdayContainer, fridayContainer, saturdayContainer]
        
        for view: UIView? in containers {
            let tapGesture = UITapGestureRecognizer(target: self, action: "containerTapped:")
            view?.addGestureRecognizer(tapGesture)
        }
        
        thursdayLabel?.font = UIFont.em_detailFontOfSize(15.0)
        fridayLabel?.font = UIFont.em_detailFontOfSize(15.0)
        saturdayLabel?.font = UIFont.em_detailFontOfSize(15.0)
        
        scheduleCollectionView?.dataSource = self.dataSource
        scheduleCollectionView?.registerNib(UINib(nibName: "CADEMScheduleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CADArrayDataSource.CADCellIdentifier)
        
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
    
    func containerTapped(sender: UITapGestureRecognizer) {
        let containers: Array<UIView?> = [thursdayContainer, fridayContainer, saturdayContainer]
        
        for selectedView: UIView? in containers.filter({ (view: UIView?) -> Bool in
            return view?.tag == sender.view?.tag
        }) {
            selectedView?.backgroundColor = UIColor.em_scheduleHeaderBackgroundColor()
            
            if let label = selectedView?.subviews.first as? UILabel {
                label.textColor = UIColor.whiteColor()
            }
        }
        
        for unSelectedView: UIView? in containers.filter({ (view: UIView?) -> Bool in
            return view?.tag != sender.view?.tag
        }) {
            unSelectedView?.backgroundColor = UIColor.em_scheduleHeaderDeselectedBackgroundColor()
            
            if let label = unSelectedView?.subviews.first as? UILabel {
                label.textColor = UIColor.em_scheduleHeaderDeselectedTextColor()
            }
        }
        
        if let tag = sender.view?.tag {
            self.viewModel.dayIndex = tag
            self.scheduleCollectionView?.reloadData()
        }
    }
}
