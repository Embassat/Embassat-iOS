//
//  ScheduleViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

class ScheduleViewController: EmbassatRootViewController {
    
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
    
    required init(_ viewModel: ScheduleViewModel) {
        dataSource = ArrayDataSource(
            viewModel: viewModel,
            configureCellBlock: { cell, indexPath in
                guard let cell = cell as? ScheduleCollectionViewCell else { return }
                                        
                cell.startTimeSting = viewModel.startTimeString(forIndexPath: indexPath)
                cell.endTimeString = viewModel.endTimeString(forIndexPath: indexPath)
                cell.artistName = viewModel.artistName(forIndexPath: indexPath)
                cell.stageName = viewModel.stageName(forIndexPath: indexPath)
                cell.shouldShowFavorite = viewModel.favoritedStatus(forIndexPath: indexPath)
                cell.backgroundColor = viewModel.backgroundColor(forIndexPath: indexPath)
            },
            configureHeaderBlock: nil)
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
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
        let artistViewController = ArtistDetailViewController()
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
