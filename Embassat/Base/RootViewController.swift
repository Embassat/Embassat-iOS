//
//  RootViewController.swift
//  Embassa't
//
//  Created by Joan Romano on 14/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    let tapGestureToResign: UITapGestureRecognizer
    
    override init(nibName nibNameOrNil: String?, bundle nibBundle: Bundle?) {
        tapGestureToResign = UITapGestureRecognizer()
        tapGestureToResign.cancelsTouchesInView = false
        
        super.init(nibName: nibNameOrNil, bundle: nibBundle)
        
        tapGestureToResign.addTarget(self, action: #selector(tapRecognizerToResignFieldsDidTrigger))
        self.view.addGestureRecognizer(tapGestureToResign)
    }
    
    required init?(coder aDecoder: NSCoder) {
        tapGestureToResign = UITapGestureRecognizer()
        tapGestureToResign.cancelsTouchesInView = false
        
        super.init(coder: aDecoder)
        
        tapGestureToResign.addTarget(self, action: #selector(tapRecognizerToResignFieldsDidTrigger))
        self.view.addGestureRecognizer(tapGestureToResign)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(tapGestureToResign)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadData()
    }
    
    func loadData() {}
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShowOrHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShowOrHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillBecomeHidden(_ keyboardHidden: Bool, animationDuration: TimeInterval, curve: UIViewAnimationCurve, keyboardHeight: CGFloat) {
        var insets: UIEdgeInsets
        
        if  let firstResponder: UIView = self.view.findFirstResponder(),
            let parentScrollView = firstResponder.findParentScrollView() {
            insets = UIEdgeInsets.zero
            insets.top = self.topLayoutGuide.length
            insets.bottom = keyboardHidden ? 0.0 : keyboardHeight
            UIView.animate(withDuration: animationDuration, animations: { () -> Void in
                parentScrollView.contentInset = insets
                parentScrollView.scrollIndicatorInsets = insets
            }, completion: { (finished) -> Void in
                if !keyboardHidden {
                    if let superView = firstResponder.superview {
                        parentScrollView.scrollRectToVisible(superView.convert(firstResponder.frame, to: parentScrollView), animated: true)
                    }
                }
            })
        }
    }
    
    func tapRecognizerToResignFieldsDidTrigger() {
        self.view.endEditing(true)
    }
    
    func keyboardShowOrHideNotification(_ notification: Notification) {
        self.keyboardWillBecomeHidden(notification.name == NSNotification.Name.UIKeyboardWillHide, notificationInfo: notification.userInfo! as NSDictionary)
    }
    
    func keyboardWillBecomeHidden(_ keyboardHidden: Bool, notificationInfo: NSDictionary) {
        var animationCurve: UIViewAnimationCurve?
        (notificationInfo[UIKeyboardAnimationCurveUserInfoKey] as AnyObject).getValue(&animationCurve)
        
        var keyboardFrameAtEndOfAnimation: CGRect?
        (notificationInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).getValue(&keyboardFrameAtEndOfAnimation)
        let keyboardHeight: CGFloat = keyboardFrameAtEndOfAnimation!.height
        let animationDuration: TimeInterval? = (notificationInfo[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        self.keyboardWillBecomeHidden(keyboardHidden, animationDuration: animationDuration!, curve: animationCurve!, keyboardHeight: keyboardHeight)
    }
}
