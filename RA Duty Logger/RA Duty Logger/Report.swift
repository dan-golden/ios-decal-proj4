//
//  Report.swift
//  RA Duty Logger
//
//  Created by Daniel Golden on 12/5/15.
//  Copyright © 2015 iOS Decal. All rights reserved.
//

import UIKit

class Report: NSObject {
    private var template: Template!
    private var items: [ReportItem]!
    private var editable: Bool!
    
    init(reportTemplate: Template) {
        template = reportTemplate
        items = template.getItems()
        editable = false
    }
    
    func isEditable() -> Bool {
        return editable
    }
    
    func getItems() -> [ReportItem] {
        return items
    }
    
    func getReportItem(index: Int) -> ReportItem {
        return items[index]
    }
    
    func fillReportItemData(data: ReportItem, index: Int) {
        items[index] = data
    }
}
