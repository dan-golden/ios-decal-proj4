//
//  ReportTableViewController.swift
//  RA Duty Logger
//
//  Created by Daniel Golden on 12/6/15.
//  Copyright © 2015 iOS Decal. All rights reserved.
//

import UIKit
import MessageUI

protocol ReportDelegate {
    func setReportFields(items: [ReportItem])
    func setReportObj(reportForm: Report)
}

class ReportTableViewController: UITableViewController, ReportDelegate, MFMailComposeViewControllerDelegate {

    var reportItems: [ReportItem]!
    var delegate: MainScreenReportsDelegate?
    var report: Report?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Draft Report"
        //Register cells to be reusable, used in cellForRowAtIndexPath
        tableView.registerClass(ReportItemCell.self, forCellReuseIdentifier: "report item cell")
        tableView.registerClass(TitleEntryCell.self, forCellReuseIdentifier: "report title cell")
        //Set up the navigation bar
        let saveButton = UIBarButtonItem(title: "Save Draft", style: .Plain, target: self, action: "saveReport")
        let sendButton = UIBarButtonItem(title: "Send", style: .Plain, target: nil, action: "sendReport")
        self.navigationItem.rightBarButtonItem = sendButton
        self.navigationItem.leftBarButtonItem = saveButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setReportFields(items: [ReportItem]) {
        reportItems = items
    }
    
    func setReportObj(reportForm: Report) {
        report = reportForm
    }
    
    func sendReport() {
        //Populate the report object with the proper values from the UI
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TitleEntryCell
        let title = cell.titleTextField.text
        for(var i = 0; i<reportItems.count; i++) {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i+1, inSection: 0)) as! ReportItemCell
            reportItems[i].setTitle(cell.getTitle())
            reportItems[i].setDate(cell.getDate())
            reportItems[i].setStartTime(cell.getStartTime())
            reportItems[i].setEndTime(cell.getEndTime())
            reportItems[i].setTextField(cell.getTextEntry())
        }
        if report == nil {
            report = Report(reportItems: reportItems, title: title!)
            report?.setNotification(UILocalNotification())
        } else {
            report!.setReportTitle(title!)
            report!.setItems(reportItems)
        }
        //Setup and present MailComposeViewController
        if(MFMailComposeViewController.canSendMail()) {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setSubject(title!)
            mailVC.setMessageBody((report?.getReportHTMLString())!, isHTML: true)
            self.presentViewController(mailVC, animated: true, completion: nil)
        }
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        if result == MFMailComposeResultSent {
            //Add report to completed section and cancel it's notification
            delegate?.addSentReport(report!)
            UIApplication.sharedApplication().cancelLocalNotification(report!.getNotification())
            controller.dismissViewControllerAnimated(true, completion: nil)
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func saveReport() {
        //Populate report object from UI
        let titleCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TitleEntryCell
        let title = titleCell.titleTextField.text
        for(var i = 0; i<reportItems.count; i++) {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i+1, inSection: 0)) as! ReportItemCell
            reportItems[i].setTitle(cell.getTitle())
            reportItems[i].setDate(cell.getDate())
            reportItems[i].setStartTime(cell.getStartTime())
            reportItems[i].setEndTime(cell.getEndTime())
            reportItems[i].setTextField(cell.getTextEntry())
        }
        if report == nil {
            report = Report(reportItems: reportItems, title: title!)
            report?.setNotification(UILocalNotification())
            delegate?.addReport(report!)
        } else {
            report!.setReportTitle(title!)
            report!.setItems(reportItems)
            UIApplication.sharedApplication().cancelLocalNotification(report!.getNotification())
            delegate?.updateCellTitle(title!)
        }
        //Set up notification for report send reminder
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: reportItems.count+1, inSection: 0)) as! ReportItemCell
        let notification = report?.getNotification()
        notification?.alertBody = "Send Duty Log: " + title!
        let dateFormatter = NSDateFormatter()
        let timeFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        timeFormatter.dateFormat = "h:mm a"
        let dateString = dateFormatter.stringFromDate(cell.getDate()!)
        let timeString = timeFormatter.stringFromDate(cell.getStartTime()!)
        dateFormatter.dateFormat = "MM/dd/yyy, h:mm a"
        notification?.fireDate = dateFormatter.dateFromString(dateString+", "+timeString)
        notification?.alertAction = "open"
        notification?.soundName = UILocalNotificationDefaultSoundName
        report?.setNotification(notification!)
        UIApplication.sharedApplication().scheduleLocalNotification(report!.getNotification())
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportItems.count + 2
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            //Set up title cell to name the report
            let cell = tableView.dequeueReusableCellWithIdentifier("report title cell", forIndexPath: indexPath) as! TitleEntryCell
            cell.titleTextField = UITextField(frame: CGRectMake(15, 0, UIScreen.mainScreen().bounds.width-30, 45))
            cell.titleTextField.borderStyle = UITextBorderStyle.None
            cell.titleTextField.placeholder = "Report Title"
            cell.titleTextField.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
            if report != nil {
                cell.titleTextField.text = report?.getReportTitle()
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.contentView.addSubview(cell.titleTextField)
            return cell
        } else if indexPath.row <= reportItems.count {
            //Create report item cell
            let cell = tableView.dequeueReusableCellWithIdentifier("report item cell", forIndexPath: indexPath) as! ReportItemCell
            let item = reportItems[indexPath.row-1]
            //Crashes here if template is empty, add check later on template screen
            cell.setupCell(item.getTitle()!, date: item.needsDate(), startTime: item.needsStartTime(), endTime: item.needsEndTime(), text: item.needsText())
            if item.needsDate()  {
                cell.setDate(item.getDate()!)
            }
            if item.needsStartTime() {
                cell.setStartTime(item.getStartTime()!)
            }
            if item.needsEndTime() {
                cell.setEndTime(item.getEndTime()!)
            }
            if item.needsText() {
                let text = item.getTextEntry()!
                if text == "" {
                    cell.setTextEntry("Enter description")
                } else {
                    cell.setTextEntry(text)
                }
            }
            return cell
        } else {
            //Create reminder settings cell
            let cell = tableView.dequeueReusableCellWithIdentifier("report item cell", forIndexPath: indexPath) as! ReportItemCell
            cell.setupCell("Send Reminder", date: true, startTime: true, endTime: false, text: false)
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height = 50
        if indexPath.row != 0 && indexPath.row != reportItems.count+1 {
            let item = reportItems[indexPath.row-1]
            if item.needsDate() {
                height = height + 50
            }
            if item.needsStartTime() {
                height = height + 50
            }
            if item.needsEndTime() {
                height = height + 50
            }
            if item.needsText() {
                height = height + 100
            }
        } else if indexPath.row == reportItems.count+1 {
            return 150
        }
        return CGFloat(height)
    }

}
