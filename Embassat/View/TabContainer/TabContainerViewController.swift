//
//  TabContainerViewController.swift
//  Embassat
//
//  Created by Joan Romano on 20/5/17.
//  Copyright © 2017 Crows And Dogs. All rights reserved.
//

import UIKit

final class TabContainerViewController: UIViewController {
    
    var selectedIndex: Int
    let viewModel: TabContainerViewModel
    
    let tabContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        return container
    }()
    
    init(viewModel: TabContainerViewModel) {
        self.viewModel = viewModel
        self.selectedIndex = viewModel.initialIndex
        super.init(nibName: nil, bundle: nil)
        title = viewModel.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .secondary
        view.addSubview(tabContainer)
        tabContainer.heightAnchor.constraint(equalToConstant: 38).isActive = true
        tabContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tabContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tabContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: topLayoutGuide.length).isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard tabContainer.subviews.count == 0 else { return }
        
        let tabWidth = view.bounds.width / CGFloat(viewModel.sections.count)
        for (index, section) in viewModel.sections.enumerated() {
            let tab = UIView()
            tab.translatesAutoresizingMaskIntoConstraints = false
            let label = UILabel()
            label.font = UIFont.detailFont(ofSize: 15.0)
            label.translatesAutoresizingMaskIntoConstraints = false
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tabTapped))
            tab.addGestureRecognizer(tapGesture)
            label.text = section.title
            
            tab.addSubview(label)
            tabContainer.addSubview(tab)
            
            label.centerXAnchor.constraint(equalTo: tab.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: tab.centerYAnchor).isActive = true
            tab.widthAnchor.constraint(equalToConstant: tabWidth).isActive = true
            tab.topAnchor.constraint(equalTo: tabContainer.topAnchor).isActive = true
            tab.bottomAnchor.constraint(equalTo: tabContainer.bottomAnchor).isActive = true
            
            if index == 0 {
                tab.leadingAnchor.constraint(equalTo: tabContainer.leadingAnchor).isActive = true
            } else {
                let previousView = tabContainer.subviews[tabContainer.subviews.count - 2]
                tab.leadingAnchor.constraint(equalTo: previousView.trailingAnchor).isActive = true
            }
            
            if index == viewModel.sections.count - 1 {
                tab.trailingAnchor.constraint(equalTo: tabContainer.trailingAnchor).isActive = true
            }
        }
        
        tabTapped(tabContainer.subviews[selectedIndex].gestureRecognizers?.first)
    }
    
    override var childViewControllerForStatusBarStyle : UIViewController? {
        return viewModel.sections[selectedIndex].viewController
    }

    @objc fileprivate func tabTapped(_ sender: UIGestureRecognizer?) {
        guard let selectedView = sender?.view,
              let newSelectedIndex = tabContainer.subviews.index(of: selectedView) else { return }
        
        let currentViewController = viewModel.sections[selectedIndex].viewController
        currentViewController.willMove(toParentViewController: nil)
        currentViewController.view.removeFromSuperview()
        currentViewController.removeFromParentViewController()
        
        selectedIndex = newSelectedIndex
        let newViewController = viewModel.sections[selectedIndex].viewController
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChildViewController(newViewController)
        view.addSubview(newViewController.view)
        newViewController.didMove(toParentViewController: self)
        
        newViewController.view.topAnchor.constraint(equalTo: tabContainer.bottomAnchor).isActive = true
        newViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        newViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        tabContainer.subviews.enumerated()
            .filter { return $0.offset == selectedIndex }
            .forEach { (_, view) in
                view.backgroundColor = .secondary
                (view.subviews.first as! UILabel).textColor = .primary
        }
        
        tabContainer.subviews.enumerated()
            .filter { return $0.offset != selectedIndex }
            .forEach { (_, view) in
                view.backgroundColor = UIColor.primary.withAlphaComponent(0.5)
                (view.subviews.first as! UILabel).textColor = .secondary
        }
        
        setNeedsStatusBarAppearanceUpdate()
    }
}
