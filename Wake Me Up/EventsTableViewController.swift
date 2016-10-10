//
//  EventsTableViewController.swift
//  Wake Me Up
//
//  Created by Pritam Hinger on 10/10/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController, EditEventViewControllerDelegate {

    private let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    }
    
    @IBAction func createEvent(sender: AnyObject) {
        self.performSegueWithIdentifier("idSegueEvent", sender: nil)
    }
    
    func eventWasSuccessfullySaved() {
        print("Event Was Successfully Saved")
    }
    
}
