//
//  ScheduleViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

class ScheduleViewController: EmbassatRootViewController, UpdateableView {
    
    @IBOutlet weak var thursdayContainer: UIView?
    @IBOutlet weak var fridayContainer: UIView?
    @IBOutlet weak var saturdayContainer: UIView?
    @IBOutlet weak var sundayContainer: UIView?
    @IBOutlet weak var thursdayLabel: UILabel?
    @IBOutlet weak var fridayLabel: UILabel?
    @IBOutlet weak var saturdayLabel: UILabel?
    @IBOutlet weak var sundayLabel: UILabel?
    
    @IBOutlet weak var scheduleCollectionView: UICollectionView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    
    fileprivate var dataSource: ArrayDataSource?
    var viewModel: ScheduleViewModel {
        didSet {
            updateDataSource()
            activityIndicator?.stopAnimating()
        }
    }
    
    required init(viewModel: ScheduleViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: ScheduleViewController.self), bundle: nil)
        updateDataSource()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Horaris"
        
        thursdayLabel?.font = UIFont.detailFont(ofSize: 15.0)
        fridayLabel?.font = UIFont.detailFont(ofSize: 15.0)
        saturdayLabel?.font = UIFont.detailFont(ofSize: 15.0)
        sundayLabel?.font = UIFont.detailFont(ofSize: 15.0)
        thursdayLabel?.textColor = UIColor.emScheduleHeaderSelectedTextColor()
        thursdayContainer?.backgroundColor = UIColor.emScheduleHeaderSelectedBackgroundColor()
        
        for view in [thursdayContainer, fridayContainer, saturdayContainer, sundayContainer] {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(containerTapped))
            view?.addGestureRecognizer(tapGesture)
        }
        
        scheduleCollectionView?.register(UINib(nibName: String(describing: ScheduleCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: ArrayDataSource.CADCellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.shouldRefreshModel()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        viewModel.didSelect(at: indexPath.item)
    }
    
    @objc fileprivate func containerTapped(_ sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else { return }
        
        let selectedBackgroundColor = UIColor.emScheduleHeaderSelectedBackgroundColor()
        let unselectedBackgroundColor = UIColor.emScheduleHeaderDeselectedBackgroundColor()
        
        let containers = [thursdayContainer, fridayContainer, saturdayContainer, sundayContainer].flatMap { $0 }
        
        for selectedView in containers.subviews(withTag: tag) {
            selectedView.backgroundColor = selectedBackgroundColor
            
            if let label = selectedView.subviews.first as? UILabel {
                label.textColor = UIColor.emScheduleHeaderSelectedTextColor()
            }
        }
        
        for unSelectedView in containers.subviews(withoutTag: tag) {
            unSelectedView.backgroundColor = unselectedBackgroundColor
            
            if let label = unSelectedView.subviews.first as? UILabel {
                label.textColor = UIColor.emScheduleHeaderDeselectedTextColor()
            }
        }
        
        viewModel.dayIndex = tag
    }
    
    fileprivate func updateDataSource() {
        dataSource =
            ArrayDataSource(
                viewModel: viewModel,
                configureCellBlock: { [weak self] (cell, indexPath) in
                    guard let cell = cell as? ScheduleCollectionViewCell,
                              let viewModel = self?.viewModel else { return }
                    
                    cell.startTimeSting = viewModel.startTimeString(forIndexPath: indexPath)
                    cell.endTimeString = viewModel.endTimeString(forIndexPath: indexPath)
                    cell.artistName = viewModel.artistName(forIndexPath: indexPath)
                    cell.stageName = viewModel.stageName(forIndexPath: indexPath)
                    cell.shouldShowFavorite = viewModel.favoritedStatus(forIndexPath: indexPath)
                    cell.backgroundColor = viewModel.backgroundColor(forIndexPath: indexPath)
                },
                configureHeaderBlock: nil
        )
        scheduleCollectionView?.dataSource = dataSource
        scheduleCollectionView?.reloadData()
    }
}

private extension Array where Element: UIView {
    
    func subviews(withTag tag: Int) -> [Element] {
        return filter { $0.tag == tag }
    }
    
    func subviews(withoutTag tag: Int) -> [Element] {
        return filter { $0.tag != tag }
    }
    
}
