//
//  CADRootViewControllerSwift.swift
//  Embassa't
//
//  Created by Joan Romano on 14/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

public class CADRootViewControllerSwift: UIViewController {
    
    var tapGestureToResign: UITapGestureRecognizer
    
    convenience init() {
        self.init()
        
        tapGestureToResign = UITapGestureRecognizer()
        tapGestureToResign.cancelsTouchesInView = false
        tapGestureToResign.addTarget(self, action: "tapRecognizerToResignFieldsDidTrigger")
        self.view.addGestureRecognizer(tapGestureToResign)
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShowOrHideNotification:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShowOrHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillBecomeHidden(keyboardHidden: Bool, animationDuration: NSTimeInterval, curve: UIViewAnimationCurve, keyboardHeight: CGFloat) {
        var insets: UIEdgeInsets
        let firstResponder: UIView = self.view.findFirstResponder()
        
        if let parentScrollView = firstResponder.findParentScrollView() {
            insets = UIEdgeInsetsZero
            insets.top = self.topLayoutGuide.length
            insets.bottom = keyboardHidden ? 0.0 : keyboardHeight
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                parentScrollView.contentInset = insets
                parentScrollView.scrollIndicatorInsets = insets
            }, completion: { (finished Bool) -> Void in
                if !keyboardHidden {
                    let superView: UIView! = firstResponder.superview
                    parentScrollView.scrollRectToVisible(superView.convertRect(firstResponder.frame, toView: parentScrollView), animated: true)
                }
            })
        }
    }
    
    func tapRecognizerToResignFieldsDidTrigger() {
        self.view.endEditing(true)
    }
    
    func keyboardShowOrHideNotification(notification: NSNotification) {
        self.keyboardWillBecomeHidden(notification.name == UIKeyboardWillHideNotification, notificationInfo: notification.userInfo!)
    }
    
    func keyboardWillBecomeHidden(keyboardHidden: Bool, notificationInfo: NSDictionary) {
        var animationCurve: UIViewAnimationCurve?
        notificationInfo[UIKeyboardAnimationCurveUserInfoKey]?.getValue(&animationCurve)
        
        var keyboardFrameAtEndOfAnimation: CGRect?
        notificationInfo[UIKeyboardFrameEndUserInfoKey]?.getValue(&keyboardFrameAtEndOfAnimation)
        let keyboardHeight: CGFloat = CGRectGetHeight(keyboardFrameAtEndOfAnimation!)
        let animationDuration: NSTimeInterval? = notificationInfo[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        
        self.keyboardWillBecomeHidden(keyboardHidden, animationDuration: animationDuration!, curve: animationCurve!, keyboardHeight: keyboardHeight)
    }
    
    func showLoading() {
        SVProgressHUD.show()        
    }
    
    func hideLoading() {
        SVProgressHUD.dismiss()
    }
    
    func hideWithSucces(success: String) {
        SVProgressHUD.showSuccessWithStatus(success)
    }

    func hideWithError(error: String) {
        SVProgressHUD.showErrorWithStatus(error)
    }
}
