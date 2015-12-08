//
//  MainScreenTableViewController.swift
//  RA Duty Logger
//
//  Created by Daniel Golden on 12/5/15.
//  Copyright © 2015 iOS Decal. All rights reserved.
//

import UIKit

protocol MainScreenReportsDelegate {
    func addReport(report: Report)
    func updateCellTitle(title: String)
    func addSentReport(report: Report)
}


class MainScreenTableViewController: UITableViewController, MainScreenReportsDelegate {
    
    var templates: [Template]!
    var drafts: [Report]!
    var reports: [Report]!
    var templateDelegate: TemplateDelegate?
    var reportDelegate: ReportDelegate?
    var sentReportDelegate: SentReportDelegate?
    private var lastRowTapped: NSIndexPath?
    
    override func viewDidLoad() {
        templates = [Template]()
        drafts = [Report]()
        reports = [Report]()
        self.navigationItem.accessibilityLabel = "R A Duty Logger"
        super.viewDidLoad()
    }

    /* Add draft to table and data structure, called when draft is saved */
    func addReport(report: Report) {
        drafts.append(report)
        let indexPath = NSIndexPath(forRow: drafts.count-1, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    /* Remove corresponding draft (if applicable) and move report to sent section, called after report is sent */
    func addSentReport(report: Report) {
        reports.append(report)
        tableView.beginUpdates()
        if lastRowTapped!.row < drafts.count {
            drafts.removeAtIndex(lastRowTapped!.row)
            tableView.deleteRowsAtIndexPaths([lastRowTapped!], withRowAnimation: .Fade)
        }
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: reports.count-1, inSection: 1)], withRowAnimation: .Automatic)
        tableView.endUpdates()
    }
    
    /* On draft save, update the cell title */
    func updateCellTitle(title: String) {
        let cell = tableView.cellForRowAtIndexPath(lastRowTapped!)
        cell?.textLabel!.text = drafts[lastRowTapped!.row].getReportTitle()
    }
    
    @IBAction func unwindToMainScreen(unwindSegue: UIStoryboardSegue) {
    
    }
    
    @IBAction func unwindToMainScreenWithSave(unwindSegue: UIStoryboardSegue) {
        let newTemplateTVC = unwindSegue.sourceViewController as! NewTemplateTableViewController
        let cell = newTemplateTVC.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TitleEntryCell
        let templateName = cell.titleTextField.text!
        if lastRowTapped!.row < templates.count {
            //Existing template was updated, update its info
            templates[lastRowTapped!.row].setItems(newTemplateTVC.templateItems)
            let templateCell = tableView.cellForRowAtIndexPath(lastRowTapped!)
            templateCell?.textLabel?.text = templateName
        } else {
            //New template was added, create one and add a new row to the table
            templates.append(Template(templateItems: newTemplateTVC.templateItems, name: templateName))
            let indexPath = NSIndexPath(forRow: templates.count-1, inSection: 2)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            let newCell = tableView.cellForRowAtIndexPath(indexPath)
            newCell?.textLabel?.text = templateName
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == drafts.count {
            return tableView.dequeueReusableCellWithIdentifier("new report", forIndexPath: indexPath)
        } else if indexPath.section == 2 && indexPath.row == templates.count {
            return tableView.dequeueReusableCellWithIdentifier("new template", forIndexPath: indexPath)
        } else if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("draft cell", forIndexPath: indexPath)
            cell.textLabel?.text = drafts[indexPath.row].getReportTitle()
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("report cell", forIndexPath: indexPath)
            cell.textLabel?.text = reports[indexPath.row].getReportTitle()
            cell.accessoryType = .DisclosureIndicator
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
            return "Completed Reports"
        } else if section == 2 {
            return "Templates"
        } else {
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        lastRowTapped = indexPath
        if indexPath.section == 0 {
            //Create a report TVC for editing report
            let vc = ReportTableViewController()
            reportDelegate = vc
            vc.delegate = self
            let nav = UINavigationController(rootViewController: vc)
            if indexPath.row == drafts.count {
                //If selected new report button, display template options
                let templateSelector = UIAlertController(title: nil, message: "Select a template", preferredStyle: .ActionSheet)
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                templateSelector.addAction(cancelAction)
                for(var i = 0; i<templates.count; i++) {
                    let j = i
                    let templateAction = UIAlertAction(title: templates[i].getTitle(), style: .Default, handler: { (action) -> Void in
                        self.reportDelegate?.setReportFields(self.templates[j].getItems())
                        self.presentViewController(nav, animated: true, completion: nil)
                    })
                    templateSelector.addAction(templateAction)
                }
                presentViewController(templateSelector, animated: true, completion: nil)
            } else {
                //Edit existing report
                reportDelegate?.setReportFields(drafts[indexPath.row].getItems())
                reportDelegate?.setReportObj(drafts[indexPath.row])
                presentViewController(nav, animated: true, completion: nil)
            }
        } else if indexPath.section == 1 {
            //Create a new sent report VC for viewing finished reports
            let vc = SentReportViewController()
            sentReportDelegate = vc
            //Create attributed string for UITextView from HTML used for email body
            let html = reports[indexPath.row].getReportHTMLString()
            let data = html.dataUsingEncoding(NSUnicodeStringEncoding)!
            let font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
            let attributedText = try? NSMutableAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute : NSUTF8StringEncoding, NSFontAttributeName : font], documentAttributes: nil)
            sentReportDelegate?.populateTextView(attributedText!)
            vc.title = reports[indexPath.row].getReportTitle()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        //Don't allow deletion of new report or new template buttons
        if indexPath.section == 0 {
            if indexPath.row < drafts.count {
                return true
            } else {
                return false
            }
        } else if indexPath.section == 1 {
            if indexPath.row < reports.count {
                return true
            } else {
                return false
            }
        } else {
            if indexPath.row < templates.count {
                return true
            } else {
                return false
            }
        }
    }

    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if indexPath.section == 0 {
                //Remove draft and cancel its notification
                UIApplication.sharedApplication().cancelLocalNotification(drafts[indexPath.row].getNotification())
                drafts.removeAtIndex(indexPath.row)
            } else if indexPath.section == 1 {
                reports.removeAtIndex(indexPath.row)
            } else if indexPath.section == 2 {
                templates.removeAtIndex(indexPath.row)
            }
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.endUpdates()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.destinationViewController is UINavigationController) {
            let navVC = segue.destinationViewController as! UINavigationController
            if(navVC.childViewControllers.first is NewTemplateTableViewController) {
                //setup new template view controller for new or existing template
                let newTemplateTVC = navVC.childViewControllers.first as! NewTemplateTableViewController
                let indexPath = tableView.indexPathForSelectedRow!
                templateDelegate = newTemplateTVC
                if(indexPath.row < templates.count) {
                    templateDelegate?.setTemplateData(templates[indexPath.row].getItems())
                    templateDelegate?.setTemplateTitle(templates[indexPath.row].getTitle())
                } else {
                    templateDelegate?.setTemplateData([ReportItem]())
                    templateDelegate?.setTemplateTitle("")
                }
            }
        }
    }
    
}
