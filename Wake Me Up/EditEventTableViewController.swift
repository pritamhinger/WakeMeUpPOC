//
//  EditEventTableViewController.swift
//  Wake Me Up
//
//  Created by Pritam Hinger on 10/10/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit
import EventKit

class EditEventTableViewController: UITableViewController, DatePickerViewControllerDelegate, UITextFieldDelegate {

    var delegate:EditEventViewControllerDelegate?
    
    private var eventTitle:String?
    private var eventStartDate:NSDate?
    private var eventEndDate:NSDate?
    
    private let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTitle = nil
        eventStartDate = nil
        eventEndDate = nil
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 3
        }
        else{
            return 0
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "General Settings"
        }
        else {
            return "Alarms"
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = nil
        if indexPath.section == 0{
            if cell == nil{
                if indexPath.row == 0{
                    cell = tableView.dequeueReusableCellWithIdentifier("idCellTitle")
                }
                else{
                    cell = tableView.dequeueReusableCellWithIdentifier("idCellGeneral")
                }
            }
            
            switch indexPath.row {
            case 0:
                let textField = cell?.viewWithTag(10) as! UITextField
                textField.delegate = self
                textField.text = eventTitle
            case 1:
                if eventStartDate == nil{
                    cell?.textLabel?.text = "Choose a start date.."
                }
                else{
                    cell?.textLabel?.text = appDelegate.eventManager?.getStringFromDate(eventStartDate!)
                }
            case 2:
                if eventEndDate == nil{
                    cell?.textLabel?.text = "Choose an end date.."
                }
                else{
                    cell?.textLabel?.text = appDelegate.eventManager?.getStringFromDate(eventEndDate!)
                }
            default:
                print("Invalid Row")
            }
        }
        else{
            if cell == nil{
                cell = tableView.dequeueReusableCellWithIdentifier("idCellGeneral")
            }
        }
        
        return cell!
    }
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0) && (indexPath.row == 1 || indexPath.row == 2){
            performSegueWithIdentifier("idSegueDatepicker", sender: self)
        }
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "idSegueDatepicker" {
            let dateTimeChooserVC = segue.destinationViewController as! DatePickerViewController
            dateTimeChooserVC.delegate = self
        }
    }

    // MARK: - TextField Delegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        eventTitle = textField.text
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - IBActions
    
    @IBAction func saveEvent(sender: AnyObject) {
        if eventTitle == nil && eventTitle?.characters.count == 0{
            return
        }
        
        if eventStartDate == nil || eventEndDate == nil{
            return
        }
        
        let event = EKEvent(eventStore: (appDelegate.eventManager?.eventStore)!)
        event.title = eventTitle!
        event.calendar = (appDelegate.eventManager?.eventStore.calendarWithIdentifier((appDelegate.eventManager?.selectedCalendarIdentifier)!))!
        event.startDate = eventStartDate!
        event.endDate = eventEndDate!
        
        do{
            try appDelegate.eventManager?.eventStore.saveEvent(event, span: .FutureEvents, commit: true)
            delegate?.eventWasSuccessfullySaved()
            navigationController?.popViewControllerAnimated(true)
        }
        catch let error{
            print("Error occured while saving event. \(error)")
        }
        
    }
    
    func dateWasSelected(selectedDate: NSDate) {
        print("Selected date is : \(selectedDate)")
        let indexPath = tableView.indexPathForSelectedRow
        
        if indexPath?.section == 0{
            if indexPath?.row == 1{
                eventStartDate = selectedDate
            }
            else if indexPath?.row == 2{
                eventEndDate = selectedDate
            }
            
            tableView.reloadData()
        }
    }
}

protocol EditEventViewControllerDelegate {
    func eventWasSuccessfullySaved();
}
