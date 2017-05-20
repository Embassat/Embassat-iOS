//
//  TabContainerViewModel.swift
//  Embassat
//
//  Created by Joan Romano on 20/5/17.
//  Copyright © 2017 Crows And Dogs. All rights reserved.
//

import UIKit

/// A `TabContainerViewController` section view model
struct TabContainerSection {
    let title: String
    let viewController: UIViewController
}

/// A `TabContainerViewController` view model
final class TabContainerViewModel {
    
    let title: String
    let sections: [TabContainerSection]
    let initialIndex: Int
    let selectedBackgroundColor: UIColor
    let selectedTextColor: UIColor
    let unselectedBackgroundColor: UIColor
    let unselectedTextColor: UIColor

    init(title: String,
         sections: [TabContainerSection],
         initialIndex: Int = 0,
         selectedBackgroundColor: UIColor = .secondary,
         selectedTextColor: UIColor = .primary,
         unselectedBackgroundColor: UIColor = UIColor.primary.withAlphaComponent(0.5),
         unselectedTextColor: UIColor = .secondary) {
        self.title = title
        self.sections = sections
        self.initialIndex = initialIndex
        self.selectedBackgroundColor = selectedBackgroundColor
        self.selectedTextColor = selectedTextColor
        self.unselectedBackgroundColor = unselectedBackgroundColor
        self.unselectedTextColor = unselectedTextColor
    }
}
