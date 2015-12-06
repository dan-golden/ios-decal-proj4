//
//  NewTemplateTableViewController.swift
//  RA Duty Logger
//
//  Created by Daniel Golden on 12/5/15.
//  Copyright © 2015 iOS Decal. All rights reserved.
//

import UIKit

protocol TemplateDelegate {
    func setTemplateData(items: [ReportItem])
    func setTemplateTitle(title: String)
}


class NewTemplateTableViewController: UITableViewController, TemplateDelegate {
    
    var templateItems: [ReportItem]!
    var lastRowTapped: Int!
    var templateName: String!
    var delegate: TemplateItemDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastRowTapped = 0
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    func setTemplateData(items: [ReportItem]) {
        templateItems = items
    }
    
    func setTemplateTitle(title: String) {
        templateName = title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addItem(sender: AnyObject) {
        let newReportItem = ReportItem()
        let indexPath = NSIndexPath(forRow: templateItems.count+1, inSection: 0)
        templateItems.append(newReportItem)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    @IBAction func unwindToNewTemplate(unwindSegue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindToNewTemplateWithSave(unwindSegue: UIStoryboardSegue) {
        let templateItemTVC = unwindSegue.sourceViewController as! TemplateItemTableViewController
        delegate = templateItemTVC
        if !delegate!.getDateSwitchValue() {
            templateItems[lastRowTapped-1].setDate(nil)
        } else {
            templateItems[lastRowTapped-1].setDate(NSDate())
        }
        if !delegate!.getTextSwitchValue() {
            templateItems[lastRowTapped-1].setTextField(nil)
        } else {
            templateItems[lastRowTapped-1].setTextField("")
        }
        if !delegate!.getTiimeSwitchValue() {
            templateItems[lastRowTapped-1].setTime(nil)
        } else {
            templateItems[lastRowTapped-1].setTime(NSDate())
        }
        templateItems[lastRowTapped-1].setTitle(delegate!.getTemplateItemTitle())
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: lastRowTapped, inSection: 0))
        cell?.textLabel?.text = templateItemTVC.titleField.text!
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templateItems.count+2
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("template title", forIndexPath: indexPath) as! TitleEntryCell
            cell.titleTextField.text = templateName
            return cell
        } else if indexPath.row == templateItems.count + 1 {
            return tableView.dequeueReusableCellWithIdentifier("add template item", forIndexPath: indexPath)
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("template item", forIndexPath: indexPath)
            let itemTitle = templateItems[indexPath.row-1].getTitle()
            if(itemTitle == nil) {
                cell.textLabel!.text = "New Field"
            } else {
                cell.textLabel!.text = itemTitle
            }
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        lastRowTapped = indexPath.row
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            tableView.beginUpdates()
            templateItems.removeAtIndex(indexPath.row-1)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.endUpdates()
        }
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if(indexPath.row == 0 || indexPath.row == templateItems.count+1) {
            return false
        } else {
            return true
        }
    }

/*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    } */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is UINavigationController {
            let navVC = segue.destinationViewController as! UINavigationController
            if(navVC.childViewControllers.first is TemplateItemTableViewController) {
                let row = tableView.indexPathForSelectedRow!.row - 1
                let templateItemTVC = navVC.childViewControllers.first as! TemplateItemTableViewController
                _ = templateItemTVC.view
                delegate = templateItemTVC
                delegate?.toggleDate(templateItems[row].needsDate())
                delegate?.toggleTime(templateItems[row].needsTime())
                delegate?.toggleText(templateItems[row].needsText())
                delegate?.setTemplateItemTitle(templateItems[row].getTitle())
            }
        }
    }

}
