//
//  TabContainerViewModel.swift
//  Embassat
//
//  Created by Joan Romano on 20/5/17.
//  Copyright © 2017 Crows And Dogs. All rights reserved.
//

import UIKit

struct TabContainerSection {
    let title: String
    let viewController: UIViewController
}

final class TabContainerViewModel {
    
    let title: String
    let sections: [TabContainerSection]
    let initialIndex: Int

    init(title: String,
         sections: [TabContainerSection],
         initialIndex: Int = 0) {
        self.title = title
        self.sections = sections
        self.initialIndex = initialIndex
    }
    
    
}
