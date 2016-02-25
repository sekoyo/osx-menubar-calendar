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
            button.title = getDateTimeStr()
            button.action = Selector("togglePopover:")
            button.sendActionOn(Int(NSEventMask.LeftMouseUpMask.union(NSEventMask.RightMouseUpMask).rawValue))
        }
        
        popover.contentViewController = CalendarViewController(nibName: "CalendarViewController", bundle: nil)
        
        eventMonitor = EventMonitor(mask: [.LeftMouseDownMask, .RightMouseDownMask]) { [unowned self] event in
            if self.popover.shown {
                self.closePopover(event)
            }
        }
        eventMonitor?.start()
        
        // Loop every minute to update the time.
        startMinuteLoop()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func showPopover(sender: AnyObject?) {
        let event:NSEvent! = NSApp.currentEvent!
        if (event.type == NSEventType.RightMouseUp) {

            let myPopup: NSAlert = NSAlert()
            myPopup.messageText = "Quit"
            myPopup.informativeText = "Are you sure you want to quit Menubar Calendar?"
            myPopup.alertStyle = NSAlertStyle.WarningAlertStyle
            myPopup.addButtonWithTitle("Quit")
            myPopup.addButtonWithTitle("Cancel")
            let res = myPopup.runModal()
            if res == NSAlertFirstButtonReturn {
                exit(0)
            }

        } else if let button = statusItem.button {
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

    func getDateTimeStr() -> String {
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "E d MMM, HH:mm"
        return formatter.stringFromDate(date)
    }
    
    func startMinuteLoop() {
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "ss";
        let currentTimeSeconds = Double(dateFormatter.stringFromDate(currentDate))
        let fireDate = NSDate(timeIntervalSinceNow: 60 - currentTimeSeconds!)
        
        let timer = NSTimer(fireDate: fireDate, interval: 60, target: self, selector: "minuteLoop", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
    }
    
    func minuteLoop() {
        if let button = statusItem.button {
            button.title = getDateTimeStr()
        }
    }


}

