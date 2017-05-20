//
//  ScheduleViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

final class ScheduleViewController: EmbassatRootViewController, UpdateableView {
    
    @IBOutlet var daysContainer: UIView!
    @IBOutlet var fridayContainer: UIView!
    @IBOutlet var saturdayContainer: UIView!

    @IBOutlet var fridayLabel: UILabel!
    @IBOutlet var saturdayLabel: UILabel!
    
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
        title = "Horaris"
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
        
        viewModel.shouldRefreshModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let insets = UIEdgeInsets(top: topLayoutGuide.length + daysContainer.bounds.height,
                                  left: 0,
                                  bottom: bottomLayoutGuide.length,
                                  right: 0)
        scheduleCollectionView.contentInset = insets
        scheduleCollectionView.scrollIndicatorInsets = insets
        
        daysContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: topLayoutGuide.length).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        viewModel.didSelect(at: indexPath.item)
    }
    
    @objc fileprivate func containerTapped(_ sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else { return }
        
        let selectedBackgroundColor = UIColor.secondary
        let unselectedBackgroundColor = UIColor.primary.withAlphaComponent(0.5)
        
        let containers = [fridayContainer, saturdayContainer].flatMap { $0 }
        
        for selectedView in containers.subviews(withTag: tag) {
            selectedView.backgroundColor = selectedBackgroundColor
            
            if let label = selectedView.subviews.first as? UILabel {
                label.textColor = UIColor.primary
            }
        }
        
        for unSelectedView in containers.subviews(withoutTag: tag) {
            unSelectedView.backgroundColor = unselectedBackgroundColor
            
            if let label = unSelectedView.subviews.first as? UILabel {
                label.textColor = UIColor.secondary
            }
        }
        
        viewModel.dayIndex = tag
    }
    
    fileprivate func setupSubviews() {
        fridayLabel.font = UIFont.detailFont(ofSize: 15.0)
        saturdayLabel.font = UIFont.detailFont(ofSize: 15.0)
        
        let views = [fridayContainer, saturdayContainer].flatMap { $0 }
        for (index, view) in views.enumerated() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(containerTapped))
            view.addGestureRecognizer(tapGesture)
            if index == 0 { containerTapped(tapGesture) }
        }
        
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

private extension Array where Element: UIView {
    
    func subviews(withTag tag: Int) -> [Element] {
        return filter { $0.tag == tag }
    }
    
    func subviews(withoutTag tag: Int) -> [Element] {
        return filter { $0.tag != tag }
    }
    
}
