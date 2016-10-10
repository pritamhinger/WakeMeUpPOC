//
//  EventManager.swift
//  Wake Me Up
//
//  Created by Pritam Hinger on 10/10/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import EventKit
import Foundation

class EventManager: NSObject {
    
    private var _eventsAccessGranted:Bool = false
    private var _selectedCalendarIdentifier = ""
    
    var eventStore:EKEventStore
    
    var selectedCalendarIdentifier:String{
        get{
            return _selectedCalendarIdentifier
        }
        set{
            _selectedCalendarIdentifier = newValue
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setValue(newValue, forKey: "eventkit_selected_calendar")
        }
    }
    
    var eventsAccessGranted:Bool{
        get{
            return _eventsAccessGranted
        }
        set{
            _eventsAccessGranted = newValue
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setBool(newValue, forKey: "eventkit_events_access_granted")
        }
    }
    
    override init() {
        self.eventStore = EKEventStore()
        super.init()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let eventsAccessGrantedValue = userDefaults.valueForKey("eventkit_events_access_granted") as? Bool{
            eventsAccessGranted = eventsAccessGrantedValue
        }
        else{
            eventsAccessGranted = false
        }
        
        if let selectedCalendarIdentifierValue = userDefaults.valueForKey("eventkit_selected_calendar") as? String{
            selectedCalendarIdentifier = selectedCalendarIdentifierValue
        }
        else{
            selectedCalendarIdentifier = ""
        }
    }
    
    func getLocalEventCalendars() -> NSArray {
        let allCalendars = eventStore.calendarsForEntityType(.Event)
        let localCalendars = NSMutableArray()
        for currentCalendar in allCalendars {
            print("Current Calendar type is :\(currentCalendar.type) and title is :\(currentCalendar.title)")
            if currentCalendar.type == .Local{
                localCalendars.addObject(currentCalendar)
            }
        }
        
        return localCalendars
    }
}