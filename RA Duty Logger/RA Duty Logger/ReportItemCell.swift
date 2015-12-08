//
//  ReportItemCell.swift
//  RA Duty Logger
//
//  Created by Daniel Golden on 12/6/15.
//  Copyright © 2015 iOS Decal. All rights reserved.
//

import UIKit

class ReportItemCell: UITableViewCell {
    
    var itemLabel: UILabel?
    var dateField: UIDatePicker?
    var startTimeField: UIDatePicker?
    var endTimeField: UIDatePicker?
    var textField: UITextView?  
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func getTitle() -> String? {
        return itemLabel?.text
    }
    
    func getDate() -> NSDate? {
        return dateField?.date
    }
    
    func getStartTime() -> NSDate? {
        return startTimeField?.date
    }
    
    func getEndTime() -> NSDate? {
        return endTimeField?.date
    }
    
    func getTextEntry() -> String? {
        return textField?.text
    }
    
    func setTitle(itemTitle: String?) {
        itemLabel?.text = itemTitle
    }
    
    func setDate(itemDate: NSDate) {
        dateField?.date = itemDate
    }
    
    func setStartTime(itemStartTime: NSDate) {
        startTimeField?.date = itemStartTime
    }
    
    func setEndTime(itemEndTime: NSDate) {
        endTimeField?.date = itemEndTime
    }
    
    func setTextEntry(itemText: String) {
        textField?.text = itemText
    }
    
    /*Create the cell UI so that it contains the correct elements and add it to the cell's view*/
    func setupCell(title: String, date: Bool, startTime: Bool, endTime: Bool, text: Bool) {
        let screen = UIScreen.mainScreen().bounds.size
        var numElements = 1
        let rect = CGRectMake(0,0,screen.width,300)
        let cellView = UIView(frame: rect)
        itemLabel = UILabel(frame: CGRectMake(15, 10, screen.width-30, 45))
        itemLabel?.text = title
        itemLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cellView.addSubview(itemLabel!)
        if date {
            numElements++
            let dateLabel = UILabel(frame: CGRectMake(15, CGFloat(numElements-1)*50, 100, 45))
            dateLabel.text = "Date"
            dateLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
            dateField = UIDatePicker(frame: CGRectMake(115, CGFloat(numElements-1)*50, screen.width-130, 45))
            dateField?.datePickerMode = UIDatePickerMode.Date
            cellView.addSubview(dateLabel)
            cellView.addSubview(dateField!)
        } else {
            dateField = nil
        }
        if startTime {
            numElements++
            let startTimeLabel = UILabel(frame: CGRectMake(15, CGFloat(numElements-1)*50, 100, 45))
            startTimeLabel.text = "Start Time"
            startTimeLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
            startTimeField = UIDatePicker(frame: CGRectMake(115, CGFloat(numElements-1)*50, screen.width-130, 45))
            startTimeField?.datePickerMode = UIDatePickerMode.Time
            cellView.addSubview(startTimeField!)
            cellView.addSubview(startTimeLabel)
        } else {
            startTimeField = nil
        }
        if endTime {
            numElements++
            let endTimeLabel = UILabel(frame: CGRectMake(15, CGFloat(numElements-1)*50, 100, 45))
            endTimeLabel.text = "End Time"
            endTimeLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
            endTimeField = UIDatePicker(frame: CGRectMake(115, CGFloat(numElements-1)*50, screen.width-130, 45))
            endTimeField?.datePickerMode = UIDatePickerMode.Time
            cellView.addSubview(endTimeField!)
            cellView.addSubview(endTimeLabel)
        } else {
            endTimeField = nil
        }
        if text {
            numElements++
            textField = UITextView(frame: CGRectMake(10, CGFloat(numElements-1)*50, screen.width-20, 100))
            textField?.text = "Enter Description"
            textField?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
            cellView.addSubview(textField!)
        } else {
            textField = nil
        }
        contentView.addSubview(cellView)
        selectionStyle = UITableViewCellSelectionStyle.None
    }
    
}
