//
//  InfoContainerViewModel.swift
//  Embassat
//
//  Created by Joan Romano on 20/5/17.
//  Copyright © 2017 Crows And Dogs. All rights reserved.
//

import UIKit

struct ContainerSection {
    let title: String
    let viewController: UIViewController
}

final class InfoContainerViewModel {
    
    let sections: [ContainerSection]
    let initialIndex: Int

    init(sections: [ContainerSection], initialIndex: Int = 0) {
        self.sections = sections
        self.initialIndex = initialIndex
    }
    
    
}
