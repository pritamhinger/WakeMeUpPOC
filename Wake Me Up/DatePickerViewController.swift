//
//  DatePickerViewController.swift
//  Wake Me Up
//
//  Created by Pritam Hinger on 10/10/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    var delegate: DatePickerViewControllerDelegate?
    
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func acceptDate(sender: AnyObject) {
        delegate?.dateWasSelected(dateTimePicker.date)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}

protocol DatePickerViewControllerDelegate {
    func dateWasSelected(selectedDate: NSDate);
}
