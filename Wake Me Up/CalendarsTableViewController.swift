//
//  CalendarsTableViewController.swift
//  Wake Me Up
//
//  Created by Pritam Hinger on 10/10/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit
import EventKit

class CalendarsTableViewController: UITableViewController {

    private let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
    private var arrCalendars:NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEventCalendars()
    }
    
    func loadEventCalendars() {
        arrCalendars = appDelegate?.eventManager?.getLocalEventCalendars()
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (arrCalendars?.count)!
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCellCalendar", forIndexPath: indexPath)
        cell.accessoryType = .None
        let calendar = arrCalendars?.objectAtIndex(indexPath.row) as! EKCalendar
        cell.textLabel?.text = calendar.title
        
        if appDelegate?.eventManager?.selectedCalendarIdentifier.characters.count > 0{
            if calendar.calendarIdentifier == appDelegate?.eventManager?.selectedCalendarIdentifier{
                cell.accessoryType = .Checkmark
            }
        }
        else{
            if indexPath.row == 0{
                cell.accessoryType = .Checkmark
            }
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        appDelegate?.eventManager?.selectedCalendarIdentifier = (arrCalendars?.objectAtIndex(indexPath.row).calendarIdentifier!)!
        tableView.reloadData()
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    
    // MARK: - IBActions

    @IBAction func editCalendars(sender: AnyObject) {
    }
    
}
