//
//  UIView+CADAdditions.swift
//  Embassa't
//
//  Created by Joan Romano on 9/24/15.
//  Copyright © 2015 Crows And Dogs. All rights reserved.
//

import UIKit

extension UIView {
    
    func findFirstResponder() -> UIView? {
        if (self.isFirstResponder) {
            return self
        }
        
        for subview in self.subviews {
            if let firstResponder = subview.findFirstResponder() {
                return firstResponder
            }
        }
        
        return nil
    }
    
    func findParentScrollView() -> UIScrollView? {
        if self.isKind(of: UIScrollView.self) {
            return self as? UIScrollView
        }
        
        if let superview = self.superview {
            return superview.findParentScrollView()
        }
        
        return nil
    }
}
