//
//  CADRootViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 14/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

public class CADRootViewController: UIViewController {
    
    let tapGestureToResign: UITapGestureRecognizer
    
    override init(nibName nibNameOrNil: String?, bundle nibBundle: NSBundle?) {
        tapGestureToResign = UITapGestureRecognizer()
        tapGestureToResign.cancelsTouchesInView = false
        
        super.init(nibName: nibNameOrNil, bundle: nibBundle)
        
        tapGestureToResign.addTarget(self, action: #selector(CADRootViewController.tapRecognizerToResignFieldsDidTrigger))
        self.view.addGestureRecognizer(tapGestureToResign)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        tapGestureToResign = UITapGestureRecognizer()
        tapGestureToResign.cancelsTouchesInView = false
        
        super.init(coder: aDecoder)
        
        tapGestureToResign.addTarget(self, action: #selector(CADRootViewController.tapRecognizerToResignFieldsDidTrigger))
        self.view.addGestureRecognizer(tapGestureToResign)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(tapGestureToResign)
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadData()
    }
    
    func loadData() {}
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CADRootViewController.keyboardShowOrHideNotification(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CADRootViewController.keyboardShowOrHideNotification(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillBecomeHidden(keyboardHidden: Bool, animationDuration: NSTimeInterval, curve: UIViewAnimationCurve, keyboardHeight: CGFloat) {
        var insets: UIEdgeInsets
        
        if  let firstResponder: UIView = self.view.findFirstResponder(),
            let parentScrollView = firstResponder.findParentScrollView() {
            insets = UIEdgeInsetsZero
            insets.top = self.topLayoutGuide.length
            insets.bottom = keyboardHidden ? 0.0 : keyboardHeight
            UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                parentScrollView.contentInset = insets
                parentScrollView.scrollIndicatorInsets = insets
            }, completion: { (finished) -> Void in
                if !keyboardHidden {
                    if let superView = firstResponder.superview {
                        parentScrollView.scrollRectToVisible(superView.convertRect(firstResponder.frame, toView: parentScrollView), animated: true)
                    }
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
}
