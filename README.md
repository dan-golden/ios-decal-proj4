# RA Duty Logger

## Authors
Daniel Golden

## Purpose
When RAs are on duty, they often have to submit duty logs with a summary of
events that occurred while on duty. This app will help automate the process
and make writing duty logs simpler. 

## Fetures
* Ability to create custom templates for different types of duty reports
* Automatically generate report form UI based on your template.
  * A template can have multiple items, each containing any subset of: 
   * Date
   * Start Time
   * End Time
   * Text
* Ability to save and edit draft reports
* Ability to edit custom templates
* Notifications remind you when it's time to send a report
* View sent reports
* Ability to delete templates, drafts, or reports you no longer need
* VoiceOver Compatibility
* Automatically generate email to send to your staff when it's time to submit
the report


##Control Flow
Users get to a page with a list of drafts, completed logs and templats. They
can tapp on New Template to add a template, and then tap new field to add a
field to the template. Tapping on the template field allows you to set it's
options, such as the information needed for that field and it's titles. Tapping
save will save the field and tapping save on the template screen will save the
template. You can then tap new report and select one of your templates. The UI
will be generated automatically based on your template and you can populate the
fields and set a notification time. Tapping Save Draft will save the draft in
the drafts section. You can edit it by tapping on the table entry. Tapping Send
Report will generate an email view where you can send the report. After sending
the report, it will appear in the completed reports section and you can tap on
it to view it in a read only mode.

##Implementation
###Model
* TemplateItem.swift
* Report.swift
* Template.swift

###View
* ReportItemCell.swift
* TitleEntryCell.swift

###Controller
* TemplateItemTableViewController.swift
* NewTemplateTableViewController.swift
* MainScreenTableViewController.swift
* SentReportViewController.swift
* ReportTableViewController.swift

##What's Next
Further improvements yet to be made include:
* Implementing Core Data to persistently store Templates, Drafts, and Completed
Reports
* Adding better support for Dynamic Type (some exists currently)
* Clean up the UI so everything is lined up a little better
* Fix bugs that cause crashes on very specific edge cases
* Ability to reorder fields in a template
