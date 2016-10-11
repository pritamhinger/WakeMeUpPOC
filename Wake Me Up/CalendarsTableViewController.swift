//
//  CalendarsTableViewController.swift
//  Wake Me Up
//
//  Created by Pritam Hinger on 10/10/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit
import EventKit

class CalendarsTableViewController: UITableViewController, UITextFieldDelegate {

    private let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
    private var arrCalendars:NSArray?
    private var indexToBeDeleted:Int = 0
    
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
        if !tableView.editing{
            return (arrCalendars?.count)!
        }
        else{
            return (arrCalendars?.count)! + 1
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.editing {
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCellWithIdentifier("idCellEdit")!
                let textField = cell.viewWithTag(10) as! UITextField
                textField.delegate = self
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("idCellCalendar", forIndexPath: indexPath)
        
        if (!tableView.editing || (tableView.editing && indexPath.row != 0)) {
            
            let row = tableView.editing ? indexPath.row - 1 : indexPath.row
            let calendar = arrCalendars?.objectAtIndex(row) as! EKCalendar
            cell.textLabel?.text = calendar.title
            
            if !tableView.editing {
                cell.accessoryType = .None
                
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
            }
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if indexPath.row == 0{
            return UITableViewCellEditingStyle.Insert
        }
        else{
            return UITableViewCellEditingStyle.Delete
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        appDelegate?.eventManager?.selectedCalendarIdentifier = (arrCalendars?.objectAtIndex(indexPath.row).calendarIdentifier!)!
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Insert{
            createCalendar()
        }
        else{
            indexToBeDeleted = indexPath.row - 1
            confirmCalendarDeletion()
        }
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    
    // MARK: - IBActions

    @IBAction func editCalendars(sender: AnyObject) {
        tableView.setEditing(!tableView.editing, animated: true)
        tableView.reloadData()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        createCalendar()
        return true
    }
    
    private func confirmCalendarDeletion() {
        let calendar = arrCalendars?.objectAtIndex(indexToBeDeleted) as! EKCalendar
        let calendarIdentifier = calendar.calendarIdentifier
        print(calendar.calendarIdentifier)
        
        if appDelegate?.eventManager?.checkIfCalendarIsCustomWithIdentifier(calendarIdentifier) == false{
            let alertViewController = UIAlertController(title: "Wake Me Up Alert", message: "You are not allowed to delete this Calendar as this is created by System.", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertViewController.addAction(defaultAction)
            self.presentViewController(alertViewController, animated: true, completion: nil)
            return
        }
        else{
            let alertViewController = UIAlertController(title: "Wake Me Up Alert", message: "Are you sure you want to delete the selected calendar?", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "Yes, Go ahead..!!", style: .Default, handler: { (action) -> Void in
                print("deleting")
                do{
                    try self.appDelegate?.eventManager?.eventStore.removeCalendar(calendar, commit: true)
                    if self.appDelegate?.eventManager?.selectedCalendarIdentifier == calendarIdentifier{
                        self.appDelegate?.eventManager?.selectedCalendarIdentifier = ""
                    }
                    
                    self.appDelegate?.eventManager?.removeCalendarIdentifier(calendarIdentifier)
                    self.loadEventCalendars()
                }
                catch let error{
                    print(error)
                }
                
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)
            alertViewController.addAction(defaultAction)
            alertViewController.addAction(cancelAction)
            self.presentViewController(alertViewController, animated: true, completion: nil)
            return
        }
    }
    
    private func createCalendar(){
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let textField = tableView.cellForRowAtIndexPath(indexPath)?.viewWithTag(10) as! UITextField
        textField.resignFirstResponder()
        
        if textField.text?.characters.count == 0{
            return
        }
        
        let calendar = EKCalendar(forEntityType: .Event, eventStore: (appDelegate?.eventManager?.eventStore)!)
        calendar.title = textField.text!
        
        for source in (appDelegate?.eventManager?.eventStore.sources)! {
            if source.sourceType == EKSourceType.Local{
                calendar.source = source
            }
        }
        do{
            try appDelegate?.eventManager?.eventStore.saveCalendar(calendar, commit: true)
            tableView.setEditing(false, animated: true)
            appDelegate?.eventManager?.saveCustomCalendarIdentifier(calendar.calendarIdentifier)
            loadEventCalendars()
        }
        catch let error{
            print(error)
        }
    }
}
