//
//  TemplateItem.swift
//  RA Duty Logger
//
//  Created by Daniel Golden on 12/5/15.
//  Copyright © 2015 iOS Decal. All rights reserved.
//

import UIKit

class ReportItem: NSObject {
    private var date: NSDate?
    private var startTime: NSDate?
    private var endTime: NSDate?
    private var title: String?
    private var textField: String?
    
    func setTitle(newTitle: String?) {
        title = newTitle
    }
    
    func setDate(newDate: NSDate?) {
        date = newDate
    }
    
    func setStartTime(newTime: NSDate?) {
        startTime = newTime
    }
    
    func setEndTime(newTime: NSDate?) {
        endTime = newTime
    }
    
    func setTextField(text: String?) {
        textField = text
    }
    
    func needsDate() -> Bool {
        return !(date == nil)
    }
    
    func needsStartTime() -> Bool {
        return !(startTime == nil)
    }
    
    func needsEndTime() -> Bool {
        return !(endTime == nil)
    }
    
    func needsText() -> Bool {
        return !(textField == nil)
    }
    
    func getTitle() -> String? {
        return title
    }
    
    func getDate() -> NSDate? {
        return date
    }
    
    func getStartTime() -> NSDate? {
        return startTime
    }
    
    func getEndTime() -> NSDate? {
        return endTime
    }
    
    func getTextEntry() -> String? {
        return textField
    }
    
}
