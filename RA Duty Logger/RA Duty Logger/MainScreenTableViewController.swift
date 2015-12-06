//
//  MainScreenTableViewController.swift
//  RA Duty Logger
//
//  Created by Daniel Golden on 12/5/15.
//  Copyright © 2015 iOS Decal. All rights reserved.
//

import UIKit

var templates: [Template]!
var drafts: [Report]!
var reports: [Report]!
var delegate: TemplateDelegate?

class MainScreenTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        templates = [Template]()
        drafts = [Report]()
        reports = [Report]()
        super.viewDidLoad()
    }
    
    @IBAction func unwindToMainScreen(unwindSegue: UIStoryboardSegue) {
    
    }
    
    @IBAction func unwindToMainScreenWithSave(unwindSegue: UIStoryboardSegue) {
        let newTemplateTVC = unwindSegue.sourceViewController as! NewTemplateTableViewController
        let cell = newTemplateTVC.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TitleEntryCell
        let templateName = cell.titleTextField.text!
        templates.append(Template(templateItems: newTemplateTVC.templateItems, name: templateName))
        let indexPath = NSIndexPath(forRow: templates.count-1, inSection: 2)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        let newCell = tableView.cellForRowAtIndexPath(indexPath)
        newCell?.textLabel?.text = templateName
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == drafts.count {
            return tableView.dequeueReusableCellWithIdentifier("new report", forIndexPath: indexPath)
        } else if indexPath.section == 2 && indexPath.row == templates.count {
            return tableView.dequeueReusableCellWithIdentifier("new template", forIndexPath: indexPath)
        } else if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("draft cell", forIndexPath: indexPath)
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("report cell", forIndexPath: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("template cell", forIndexPath: indexPath)
            return cell
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return drafts.count + 1
        } else if section == 1 {
            return reports.count
        } else if section == 2 {
            return templates.count + 1
        } else {
            return 0
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3;
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Drafts"
        } else if section == 1 {
            return "Reports"
        } else if section == 2 {
            return "Templates"
        } else {
            return ""
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.destinationViewController is UINavigationController) {
            let navVC = segue.destinationViewController as! UINavigationController
            if(navVC.childViewControllers.first is NewTemplateTableViewController) {
                let newTemplateTVC = navVC.childViewControllers.first as! NewTemplateTableViewController
                let indexPath = tableView.indexPathForSelectedRow!
                delegate = newTemplateTVC
                if(indexPath.row < templates.count) {
                    delegate?.setTemplateData(templates[indexPath.row].getItems())
                    delegate?.setTemplateTitle(templates[indexPath.row].getTitle())
                } else {
                    delegate?.setTemplateData([ReportItem]())
                    delegate?.setTemplateTitle("")
                }
            }
        }
    }
    
}
