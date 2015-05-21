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
    
    let model: Array<CADEMArtistSwift>
    
    var currentArtist: CADEMArtistSwift
    var artistName: String = ""
    var artistStartHour: String = ""
    var artistStartMinute: String = ""
    var artistDay: String = ""
    var artistStage: String = ""
    var artistImageURL: NSURL? = nil
    var artistDescriptionSignal: RACSignal?
    
    public var currentIndex: Int = 0 {
        didSet {
            if currentIndex > count(model) - 1 {
               currentIndex = count(model) - 1
            }
            
            if currentIndex < 0 {
                currentIndex = 0
            }
            
            currentArtist = model[currentIndex]
            self.updateCurrentArtistData()
        }
    }
    
    init(model: Array<CADEMArtistSwift>, currentIndex: Int) {
        self.model = model
        self.currentIndex = currentIndex
        
        currentArtist = model[currentIndex]
        
        super.init()
        
        artistDescriptionSignal = RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            let descriptionString = self.currentArtist.longDescription as NSString
            if let data = descriptionString.scanStringWithStartTag("<p>", endTag: "</p>")?.stringByRemovingTags() {
                subscriber.sendNext(data)
                subscriber.sendCompleted()
            } else {
                subscriber.sendNext(nil)
                subscriber.sendCompleted()
            }
            
            return nil
        }).subscribeOn(RACScheduler(priority: RACSchedulerPriorityBackground)).deliverOn(RACScheduler.mainThreadScheduler())
        
        self.updateCurrentArtistData()
    }
    
    public func shareAction(forViewController viewController: UIViewController) {
        let item: AnyObject! = SHKItem.URL(model[0].artistURL, title: String(format: "%@ @ Embassa't", self.artistName), contentType: SHKURLContentTypeUndefined)
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
                event.startDate = self.model[0].date
                event.endDate = self.model[0].date
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
    
    func updateCurrentArtistData() {
        artistName = currentArtist.name
        artistStage = currentArtist.stage
        artistImageURL = currentArtist.imageURL
        artistStartHour = String(currentArtist.date.hour)
        artistStartMinute = String(currentArtist.date.minute)
        artistDay = "Dissabte"
    }
   
}
