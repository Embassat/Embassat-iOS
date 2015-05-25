//
//  CADEMScheduleHeaderView.swift
//  Embassa't
//
//  Created by Joan Romano on 25/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

public class CADEMScheduleHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var thursdayContainer: UIView?
    @IBOutlet weak var fridayContainer: UIView?
    @IBOutlet weak var saturdayContainer: UIView?
    @IBOutlet weak var thursdayLabel: UILabel?
    @IBOutlet weak var fridayLabel: UILabel?
    @IBOutlet weak var saturdayLabel: UILabel?
    
    public let daySelectedSignal: RACSubject = RACSubject()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        thursdayLabel?.textColor = UIColor.whiteColor()
        thursdayContainer?.backgroundColor = UIColor.em_scheduleHeaderBackgroundColor()
        
        let containers: Array<UIView?> = [thursdayContainer, fridayContainer, saturdayContainer]
        
        for view: UIView? in containers {
            let tapGesture = UITapGestureRecognizer(target: self, action: "containerTapped:")
            view?.addGestureRecognizer(tapGesture)
        }
        
        thursdayLabel?.font = UIFont.em_detailFontOfSize(15.0)
        fridayLabel?.font = UIFont.em_detailFontOfSize(15.0)
        saturdayLabel?.font = UIFont.em_detailFontOfSize(15.0)
    }
    
    func containerTapped(sender: UITapGestureRecognizer) {
        let containers: Array<UIView?> = [thursdayContainer, fridayContainer, saturdayContainer]
        
        for selectedView: UIView? in containers.filter({ (view: UIView?) -> Bool in
            return view?.tag == sender.view?.tag
        }) {
            selectedView?.backgroundColor = UIColor.em_scheduleHeaderBackgroundColor()
            
            if let label = selectedView?.subviews.first as? UILabel {
                label.textColor = UIColor.whiteColor()
            }
        }
        
        for unSelectedView: UIView? in containers.filter({ (view: UIView?) -> Bool in
            return view?.tag != sender.view?.tag
        }) {
            unSelectedView?.backgroundColor = UIColor.em_scheduleHeaderDeselectedBackgroundColor()
            
            if let label = unSelectedView?.subviews.first as? UILabel {
                label.textColor = UIColor.em_scheduleHeaderDeselectedTextColor()
            }
        }
        
        daySelectedSignal.sendNext(sender.view?.tag)
    }
}
