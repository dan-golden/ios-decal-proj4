//
//  SentReportViewController.swift
//  RA Duty Logger
//
//  Created by Daniel Golden on 12/7/15.
//  Copyright © 2015 iOS Decal. All rights reserved.
//

import UIKit

protocol SentReportDelegate {
    func populateTextView(text: NSAttributedString)
}

class SentReportViewController: UIViewController, SentReportDelegate {
    
    var reportView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(reportView)
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    func populateTextView(text: NSAttributedString) {
        reportView = UITextView(frame: CGRectMake(5, 0, UIScreen.mainScreen().bounds.width-10, UIScreen.mainScreen().bounds.height))
        reportView.editable = false
        reportView.scrollEnabled = true
        reportView.attributedText = text
    }

}
