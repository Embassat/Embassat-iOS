//
//  CADEMArtistDetailViewModel.swift
//  Embassa't
//
//  Created by Joan Romano on 17/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import Foundation
import EventKit

public class CADEMArtistDetailViewModel: NSObject {
    
    let model: CADEMArtistSwift
    let artistName, artistStartHour, artistStartMinute, artistDay, artistStage: String
    let artistImageURL: NSURL
    let artistDescriptionSignal: RACSignal
    
    init(model: CADEMArtistSwift) {
        self.model = model
        
        artistName = model.name
        artistStage = model.stage
        artistImageURL = model.imageURL
        artistStartHour = String(model.date.hour)
        artistStartMinute = String(model.date.minute)
        artistDay = "Dissabte"
        
        artistDescriptionSignal = RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            let descriptionString = model.longDescription as NSString
            if let data = descriptionString.scanStringWithStartTag("<p>", endTag: "</p>")?.stringByRemovingTags() {
                subscriber.sendNext(data)
                subscriber.sendCompleted()
            } else {
                subscriber.sendNext(nil)
                subscriber.sendCompleted()
            }
            
            return nil
        }).subscribeOn(RACScheduler(priority: RACSchedulerPriorityBackground)).deliverOn(RACScheduler.mainThreadScheduler())
    }
    
    public func shareAction(forViewController viewController: UIViewController) {
        let item: AnyObject! = SHKItem.URL(model.artistURL, title: String(format: "%@ @ Embassa't", self.artistName), contentType: SHKURLContentTypeUndefined)
        let actionSheet = SHKActionSheet(forItem: item as! SHKItem)
        SHK.setRootViewController(viewController)
        
        actionSheet.showFromToolbar(viewController.navigationController?.toolbar)
    }
    
    public func addEventOnCalendar() {
        
        let store = EKEventStore()
        
        store.requestAccessToEntityType(EKEntityTypeEvent, completion: { (granted: Bool, error: NSError!) -> Void in
            if granted {
               let event = EKEvent(eventStore: store)
                event.title = String(format: "%@ @ %@", self.artistName, self.artistStage)
                event.startDate = self.model.date
                event.endDate = self.model.date
                event.calendar = store.defaultCalendarForNewEvents
                let success: Bool = store.saveEvent(event, span: EKSpanThisEvent, commit: true, error: nil)
                if success {
                    dispatch_async(dispatch_get_main_queue()) {
                        let alertView = UIAlertView(title: "Embassa't", message: "Afegit al calendari correctament", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "D'acord", "")
                        alertView.show()
                    }
                }
            }
        })

    }
   
}
