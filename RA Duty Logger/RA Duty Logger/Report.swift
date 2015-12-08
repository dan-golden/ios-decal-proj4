//
//  Report.swift
//  RA Duty Logger
//
//  Created by Daniel Golden on 12/5/15.
//  Copyright © 2015 iOS Decal. All rights reserved.
//

import UIKit

class Report: NSObject {
    private var items: [ReportItem]!
    private var reportTitle: String!
    private var notification: UILocalNotification?

    init(reportTemplate: Template) {
        items = reportTemplate.getItems()
        reportTitle = "Template"
    }
    
    init(reportItems: [ReportItem], title: String) {
        items = reportItems
        reportTitle = title
    }
    
    func setNotification(notif: UILocalNotification) {
        notification = notif
    }
    
    func getNotification() -> UILocalNotification {
        return notification!
    }
    
    func getItems() -> [ReportItem] {
        return items
    }
    
    func setItems(reportItems: [ReportItem]) {
        items = reportItems
    }
    
    func getReportTitle() -> String {
        return reportTitle
    }
    
    func setReportTitle(title: String) {
        reportTitle = title
    }
    
    /*Generate report in HTML form*/
    func getReportHTMLString() -> String {
        let font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        var bodyText = "<span style = \"font-family: '"+font.fontName+"'; font-size: "+font.pointSize.description+"\">"
        for(var i = 0; i<items.count; i++) {
            bodyText = bodyText + "<b>"+items[i].getTitle()!+"</b><br>"
            let dateFormatter = NSDateFormatter()
            if items[i].needsDate() {
                let date = items[i].getDate()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                bodyText = bodyText + dateFormatter.stringFromDate(date!) + "<br>"
            }
            if items[i].needsStartTime() {
                let startTime = items[i].getStartTime()
                dateFormatter.dateFormat = "h:mm a"
                bodyText = bodyText + dateFormatter.stringFromDate(startTime!)
                if(items[i].needsEndTime()) {
                    bodyText = bodyText + " - "
                } else if items[i].needsText(){
                    bodyText = bodyText + ": "
                }
            }
            if items[i].needsEndTime() {
                let endTime = items[i].getEndTime()
                dateFormatter.dateFormat = "h:mm a"
                bodyText = bodyText + dateFormatter.stringFromDate(endTime!)
                if items[i].needsText() {
                    bodyText = bodyText + ": "
                }
            }
            if items[i].needsText() {
                bodyText = bodyText + items[i].getTextEntry()!
            }
            bodyText = bodyText + "<br><br>"
        }
        return bodyText + "</span>"
    }
}
