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
    func toggleTime(on: Bool)
    func toggleText(on: Bool)
    func setTemplateItemTitle(title: String?)
    func getDateSwitchValue() -> Bool
    func getTiimeSwitchValue() -> Bool
    func getTextSwitchValue() -> Bool
    func getTemplateItemTitle() -> String
}

class TemplateItemTableViewController: UITableViewController, TemplateItemDelegate {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var dateSwitch: UISwitch!
    @IBOutlet weak var timeSwitch: UISwitch!
    @IBOutlet weak var textSwitch: UISwitch!

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func toggleDate(on: Bool) {
        dateSwitch.on = on
    }
    
    func toggleText(on: Bool) {
        textSwitch.on = on
    }
    
    func toggleTime(on: Bool) {
        timeSwitch.on = on
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
    
    func getTiimeSwitchValue() -> Bool {
        return timeSwitch.on
    }
    
    func getTemplateItemTitle() -> String {
        return titleField.text!
    }
}
