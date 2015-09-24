//
//  UIView+CADAdditions.swift
//  Embassa't
//
//  Created by Joan Romano on 9/24/15.
//  Copyright © 2015 Crows And Dogs. All rights reserved.
//

import Foundation

extension UIView {    
    func findFirstResponder() -> UIView? {
        if (self.isFirstResponder()) {
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
        if self.isKindOfClass(UIScrollView) {
            return self as? UIScrollView
        }
        
        if let superview = self.superview {
            return superview.findParentScrollView()
        }
        
        return nil
    }
}
