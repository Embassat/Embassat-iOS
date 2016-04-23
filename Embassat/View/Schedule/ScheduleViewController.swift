//
//  ScheduleViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

public class ScheduleViewController: EmbassatRootViewController {
    
    @IBOutlet weak var thursdayContainer: UIView?
    @IBOutlet weak var fridayContainer: UIView?
    @IBOutlet weak var saturdayContainer: UIView?
    @IBOutlet weak var thursdayLabel: UILabel?
    @IBOutlet weak var fridayLabel: UILabel?
    @IBOutlet weak var saturdayLabel: UILabel?
    
    @IBOutlet weak var scheduleCollectionView: UICollectionView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    let dataSource: ArrayDataSource
    let viewModel: ScheduleViewModel
    
    override init(nibName nibNameOrNil: String?, bundle nibBundle: NSBundle?) {
        
        let theViewModel = ScheduleViewModel()
        dataSource = ArrayDataSource(viewModel: theViewModel,
            configureCellBlock: { (cell: AnyObject!, indexPath: NSIndexPath) -> Void in
                let theCell = cell as! ScheduleCollectionViewCell
            
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
        
        view.backgroundColor = UIColor.emBackgroundDeselectedColor()
        thursdayLabel?.textColor = UIColor.emScheduleHeaderSelectedTextColor()
        thursdayContainer?.backgroundColor = UIColor.emScheduleHeaderSelectedBackgroundColor()
        
        let containers = [thursdayContainer, fridayContainer, saturdayContainer]
        
        for view in containers {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ScheduleViewController.containerTapped(_:)))
            view?.addGestureRecognizer(tapGesture)
        }
        
        thursdayLabel?.font = UIFont.detailFont(ofSize: 15.0)
        fridayLabel?.font = UIFont.detailFont(ofSize: 15.0)
        saturdayLabel?.font = UIFont.detailFont(ofSize: 15.0)
        
        scheduleCollectionView?.dataSource = self.dataSource
        scheduleCollectionView?.registerNib(UINib(nibName: String(ScheduleCollectionViewCell), bundle: nil), forCellWithReuseIdentifier: ArrayDataSource.CADCellIdentifier)
        
        if viewModel.numberOfItemsInSection(0) > 0 {
            activityIndicator?.stopAnimating()
        }
        
        viewModel.activeSubject.subscribeNext({ [weak self] _ in
            guard let weakSelf = self else { return }
            
            weakSelf.activityIndicator?.stopAnimating()
            weakSelf.scheduleCollectionView?.reloadData()
        }, error: { [weak self] _ in
            guard let weakSelf = self else { return }
            
            weakSelf.activityIndicator?.stopAnimating()
            weakSelf.scheduleCollectionView?.reloadData()
        })
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let artistViewController = ArtistDetailViewController(nibName: String(ArtistDetailViewController), bundle: nil)
        artistViewController.viewModel = viewModel.artistViewModel(forIndexPath: indexPath)
        artistViewController.updateSignal.subscribeNext { [weak self] (_) -> Void in
            guard let weakSelf = self else { return }
            
            weakSelf.viewModel.shouldRefreshModel()
            weakSelf.scheduleCollectionView?.reloadData()
        }
        
        self.navigationController?.pushViewController(artistViewController, animated: true)
    }
    
    func containerTapped(sender: UITapGestureRecognizer) {
        let containers = [thursdayContainer, fridayContainer, saturdayContainer]
        
        for selectedView in containers.filter({ (view: UIView?) -> Bool in
            return view?.tag == sender.view?.tag
        }) {
            selectedView?.backgroundColor = UIColor.emScheduleHeaderSelectedBackgroundColor()
            
            if let label = selectedView?.subviews.first as? UILabel {
                label.textColor = UIColor.emScheduleHeaderSelectedTextColor()
            }
        }
        
        for unSelectedView in containers.filter({ (view: UIView?) -> Bool in
            return view?.tag != sender.view?.tag
        }) {
            unSelectedView?.backgroundColor = UIColor.emScheduleHeaderDeselectedBackgroundColor()
            
            if let label = unSelectedView?.subviews.first as? UILabel {
                label.textColor = UIColor.emScheduleHeaderDeselectedTextColor()
            }
        }
        
        if let tag = sender.view?.tag {
            self.viewModel.dayIndex = tag
            self.scheduleCollectionView?.reloadData()
        }
    }
}
