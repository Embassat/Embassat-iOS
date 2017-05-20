//
//  TabContainerViewController.swift
//  Embassat
//
//  Created by Joan Romano on 20/5/17.
//  Copyright © 2017 Crows And Dogs. All rights reserved.
//

import UIKit

/// A `UIViewController` container that manages his children in tabs
final class TabContainerViewController: RootViewController {
    
    private let viewModel: TabContainerViewModel
    private let tabContainer = UIView()
    
    static let tabHeight: CGFloat = 38
    
    /// The current selected index
    private(set) var selectedIndex: Int
    
    /// Initializes a new `TabContainerViewController` with the given parameters
    ///
    /// - Parameter viewModel: a `TabContainerViewModel` object
    init(viewModel: TabContainerViewModel) {
        self.viewModel = viewModel
        self.selectedIndex = viewModel.initialIndex
        super.init(nibName: nil, bundle: nil)
        title = viewModel.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .secondary
        view.addSubview(tabContainer)
        
        NSLayoutConstraint.useAndActivate([
        tabContainer.heightAnchor.constraint(equalToConstant: TabContainerViewController.tabHeight),
        tabContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tabContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.useAndActivate([
            tabContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: topLayoutGuide.length)])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard tabContainer.subviews.count == 0 else { return }
        
        addTabs()
    }
    
    override var childViewControllerForStatusBarStyle : UIViewController? {
        return viewModel.sections[selectedIndex].viewController
    }
    
    // MARK: - Private
    
    private func addTabs() {
        let tabWidth = view.bounds.width / CGFloat(viewModel.sections.count)
        for (index, section) in viewModel.sections.enumerated() {
            let tab = UIView()
            let label = UILabel()
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tabTapped))
            
            label.font = UIFont.detailFont(ofSize: 15.0)
            label.text = section.title
            tab.addGestureRecognizer(tapGesture)
            tab.addSubview(label)
            tabContainer.addSubview(tab)
            
            NSLayoutConstraint.useAndActivate([
                label.centerXAnchor.constraint(equalTo: tab.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: tab.centerYAnchor),
                tab.widthAnchor.constraint(equalToConstant: tabWidth),
                tab.topAnchor.constraint(equalTo: tabContainer.topAnchor),
                tab.bottomAnchor.constraint(equalTo: tabContainer.bottomAnchor)])
            
            if index == 0 {
                NSLayoutConstraint.useAndActivate([tab.leadingAnchor.constraint(equalTo: tabContainer.leadingAnchor)])
            } else {
                let previousView = tabContainer.subviews[tabContainer.subviews.count - 2]
                NSLayoutConstraint.useAndActivate([tab.leadingAnchor.constraint(equalTo: previousView.trailingAnchor)])
            }
            
            if index == viewModel.sections.count - 1 {
                NSLayoutConstraint.useAndActivate([tab.trailingAnchor.constraint(equalTo: tabContainer.trailingAnchor)])
            }
        }
        
        tabTapped(tabContainer.subviews[selectedIndex].gestureRecognizers?.first)
    }
    
    private func replaceCurrentTab(with newIndex: Int) {
        let currentViewController = viewModel.sections[selectedIndex].viewController
        currentViewController.em_removeFromParentViewController()
        
        selectedIndex = newIndex
        let newViewController = viewModel.sections[selectedIndex].viewController
        em_addChildViewController(newViewController)
        
        NSLayoutConstraint.useAndActivate([
            newViewController.view.topAnchor.constraint(equalTo: tabContainer.bottomAnchor),
            newViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            newViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor)])
        
        tabContainer.subviews.enumerated()
            .filter { return $0.offset == selectedIndex }
            .forEach { $0.element.toggleTagStyle(color: viewModel.selectedBackgroundColor,
                                                 textColor: viewModel.selectedTextColor) }
        
        tabContainer.subviews.enumerated()
            .filter { return $0.offset != selectedIndex }
            .forEach { $0.element.toggleTagStyle(color: viewModel.unselectedBackgroundColor,
                                                 textColor: viewModel.unselectedTextColor) }
        
        setNeedsStatusBarAppearanceUpdate()
    }

    @objc private func tabTapped(_ sender: UIGestureRecognizer?) {
        guard let selectedView = sender?.view,
              let newSelectedIndex = tabContainer.subviews.index(of: selectedView) else { return }
        
        replaceCurrentTab(with: newSelectedIndex)
    }
}

private extension UIView {
    
    func toggleTagStyle(color: UIColor, textColor: UIColor) {
        backgroundColor = color
        (subviews.first as! UILabel).textColor = textColor
    }
}
