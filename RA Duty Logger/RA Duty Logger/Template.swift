//
//  Template.swift
//  RA Duty Logger
//
//  Created by Daniel Golden on 12/5/15.
//  Copyright © 2015 iOS Decal. All rights reserved.
//

import UIKit

class Template: NSObject {
    private var items: [ReportItem]!
    private var title: String!
    
    init(templateItems: [ReportItem], name: String) {
        items = templateItems
        title = name
    }
    
    func addTemplateItem(item: ReportItem) {
        items.append(item)
    }
    
    func getItems() -> [ReportItem] {
        return items
    }
    
    func setItems(templateItems: [ReportItem]) {
        items = templateItems
    }

    func getTitle() -> String {
        return title
    }
}
