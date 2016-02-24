//
//  AppDelegate.swift
//  MenuCalendar
//
//  Created by dominic tobias on 24/02/2016.
//  Copyright © 2016 Sekai. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    
    let popover = NSPopover()
    
    var eventMonitor: EventMonitor?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if let button = statusItem.button {
            let date = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "E d MMM, HH:mm"
            
            button.title =  formatter.stringFromDate(date)
            button.action = Selector("togglePopover:")
        }
        
        popover.contentViewController = CalendarViewController(nibName: "CalendarViewController", bundle: nil)
        
        eventMonitor = EventMonitor(mask: [.LeftMouseDownMask, .RightMouseDownMask]) { [unowned self] event in
            if self.popover.shown {
                self.closePopover(event)
            }
        }
        eventMonitor?.start()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
        }
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }
    
    func togglePopover(sender: AnyObject?) {
        if popover.shown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }


}

