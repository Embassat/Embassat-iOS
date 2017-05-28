//
//  ScheduleViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

final class ScheduleViewController: RootViewController, UpdateableView {
    
    @IBOutlet var scheduleCollectionView: UICollectionView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var dataSource: ArrayDataSource?
    var viewModel: ScheduleViewModel {
        didSet {
            guard isViewLoaded else { return }
            
            updateDataSource()
            activityIndicator.stopAnimating()
        }
    }
    
    required init(viewModel: ScheduleViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: ScheduleViewController.self), bundle: nil)
        title = String.scheduleTitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        updateDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.loadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: bottomLayoutGuide.length, right: 0)
        scheduleCollectionView.contentInset = insets
        scheduleCollectionView.scrollIndicatorInsets = insets
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        viewModel.didSelect(at: indexPath.item)
    }
    
    fileprivate func setupSubviews() {
        activityIndicator.color = .primary
        scheduleCollectionView.backgroundColor = .secondary
        scheduleCollectionView.register(UINib(nibName: String(describing: ScheduleCollectionViewCell.self), bundle: nil),
                                        forCellWithReuseIdentifier: ArrayDataSource.CADCellIdentifier)
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
        scheduleCollectionView.dataSource = dataSource
        scheduleCollectionView.reloadData()
    }
}

extension ScheduleViewController: Trackeable {
    var screen: Analytics.Screen { return .schedule }
    
    var parameters: [String : Any]? { return ["schedule_day" : viewModel.dayTitle] }
}
