//
//  CalendarViewController.swift
//  MenuCalendar
//
//  Created by dominic tobias on 24/02/2016.
//  Copyright © 2016 Sekai. All rights reserved.
//

import Cocoa

class CalendarViewController: NSViewController {
    
    @IBOutlet weak var datePicker: NSDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.dateValue = NSDate()
        
    }
    
}
