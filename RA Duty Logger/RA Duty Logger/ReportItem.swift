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
    private var time: NSDate?
    private var title: String!
    private var textField: String?
    
    func setTitle(newTitle: String) {
        title = newTitle
    }
    
    func setDate(newDate: NSDate?) {
        date = newDate
    }
    
    func setTime(newTime: NSDate?) {
        time = newTime
    }
    
    func setTextField(text: String?) {
        textField = text
    }
    
    func needsDate() -> Bool {
        return !(date == nil)
    }
    
    func needsTime() -> Bool {
        return !(time == nil)
    }
    
    func needsText() -> Bool {
        return !(textField == nil)
    }
    
    func getTitle() -> String? {
        return title
    }
    
}
