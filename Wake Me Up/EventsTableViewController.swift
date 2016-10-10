//
//  EventsTableViewController.swift
//  Wake Me Up
//
//  Created by Pritam Hinger on 10/10/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit
import EventKit

class EventsTableViewController: UITableViewController, EditEventViewControllerDelegate {

    private let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.performSelector(#selector(EventsTableViewController.requestAccessToEvents), withObject: nil, afterDelay: 1.4)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCellEvent", forIndexPath: indexPath)
        cell.textLabel?.text = "Row No. \(indexPath.row)"
        return cell
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "idSegueEvent" {
            let editEventViewController = segue.destinationViewController as! EditEventTableViewController
            editEventViewController.delegate = self
            
        }
    }
 

    // MARK: - IBActions
    @IBAction func showCalendars(sender: AnyObject) {
        if appDelegate?.eventManager?.eventsAccessGranted == true{
            self.performSegueWithIdentifier("idSegueCalendars", sender: nil)
        }
    }
    
    @IBAction func createEvent(sender: AnyObject) {
        if appDelegate?.eventManager?.eventsAccessGranted == true{
            self.performSegueWithIdentifier("idSegueEvent", sender: nil)
        }
    }
    
    func eventWasSuccessfullySaved() {
        print("Event Was Successfully Saved")
    }
    
    func requestAccessToEvents() {
        appDelegate?.eventManager?.eventStore.requestAccessToEntityType(EKEntityType.Event){(accessGranted:Bool, error:NSError?) in
            if error == nil{
                self.appDelegate?.eventManager?.eventsAccessGranted = accessGranted
            }
            else{
                print("Error occured while requesting access to events store. Error is \(error?.localizedDescription)")
            }
        }
    }
}
