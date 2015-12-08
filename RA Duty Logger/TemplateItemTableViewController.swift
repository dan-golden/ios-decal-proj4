//
//  TemplateItemTableViewController.swift
//  RA Duty Logger
//
//  Created by Daniel Golden on 12/5/15.
//  Copyright © 2015 iOS Decal. All rights reserved.
//

import UIKit

protocol TemplateItemDelegate {
    func toggleDate(on: Bool)
    func toggleStartTime(on: Bool)
    func toggleEndTime(on: Bool)
    func toggleText(on: Bool)
    func setTemplateItemTitle(title: String?)
    func getDateSwitchValue() -> Bool
    func getStartTimeSwitchValue() -> Bool
    func getEndTimeSwitchValue() -> Bool
    func getTextSwitchValue() -> Bool
    func getTemplateItemTitle() -> String
}

/* View Controller for a new template item */
class TemplateItemTableViewController: UITableViewController, TemplateItemDelegate {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var dateSwitch: UISwitch!
    @IBOutlet weak var timeStartSwitch: UISwitch!
    @IBOutlet weak var timeEndSwitch: UISwitch!
    @IBOutlet weak var textSwitch: UISwitch!

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func toggleDate(on: Bool) {
        dateSwitch.on = on
    }
    
    func toggleText(on: Bool) {
        textSwitch.on = on
    }
    
    func toggleStartTime(on: Bool) {
        timeStartSwitch.on = on
    }
    
    func toggleEndTime(on: Bool) {
        timeEndSwitch.on = on
    }
    
    func setTemplateItemTitle(title: String?) {
        titleField.text = title
    }
    
    func getDateSwitchValue() -> Bool {
        return dateSwitch.on
    }
    
    func getTextSwitchValue() -> Bool {
        return textSwitch.on
    }
    
    func getStartTimeSwitchValue() -> Bool {
        return timeStartSwitch.on
    }
    
    func getEndTimeSwitchValue() -> Bool {
        return timeEndSwitch.on
    }
    
    func getTemplateItemTitle() -> String {
        return titleField.text!
    }
}
