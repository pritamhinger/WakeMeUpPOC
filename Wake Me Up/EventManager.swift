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
    var arrCustomCalendarIdentifiers = NSMutableArray()
    
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
        
        if let customCalendarIdenfierList = userDefaults.valueForKey("eventkit_cal_identifiers") as? NSMutableArray{
            arrCustomCalendarIdentifiers = NSMutableArray(array: customCalendarIdenfierList)
        }
        else{
            arrCustomCalendarIdentifiers = NSMutableArray()
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
    
    func saveCustomCalendarIdentifier(calendarIdentifier:String) {
        arrCustomCalendarIdentifiers.addObject(calendarIdentifier)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(arrCustomCalendarIdentifiers, forKey: "eventkit_cal_identifiers")
    }
    
    func checkIfCalendarIsCustomWithIdentifier(calendarIdentifier:String) -> Bool {
        var isCustomCalendar = false
        for currentCalendarIdentifier in arrCustomCalendarIdentifiers {
            if (currentCalendarIdentifier as! String) == calendarIdentifier{
                isCustomCalendar = true
                break
            }
        }
        
        return isCustomCalendar
    }
    
    func removeCalendarIdentifier(calendarIdentifier:String) {
        arrCustomCalendarIdentifiers.removeObject(calendarIdentifier)
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setObject(arrCustomCalendarIdentifiers, forKey: "eventkit_cal_identifiers")
    }
    
    func getStringFromDate(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "d MMM yyyy, HH:mm"
        return dateFormatter.stringFromDate(date)
    }
}