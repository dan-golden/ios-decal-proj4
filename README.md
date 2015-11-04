# RA Duty Logger

## Authors
Daniel Golden

## Purpose
When RAs are on duty, they often have to submit duty logs with a summary of events
that occurred while on duty. This app will help automate the process and make writing
duty logs simpler. 

## Fetures
* Add calls, lockouts, and rounds information with automatic time stamps
* Ability to add custom fiels, and reorder fields for a default duty log
* Templates that allow you to create different log fields for day vs. night duty
  * Ability to add default entries for fields in templates
* Past duty logs section to view duty logs that have been sent
* Auto-generation of email to be sent to your staff
* Notification reminder to send the duty log at a specified time.
* Ability to add default information that will be saved, such as email address to send logs to

##Control Flow
Users get to a page with a list of past duty logs. They can tap a settings button to change
defaults or tap a plus button to create a new log or a new template. On the templates screen,
they will be able to add new fields (with a label and a text entry box) and reorder these fields
amongst the built in defaults. They can then press save to name the template and save it. Tapping
new log will generate a new duty log which they can begin typing information into or save as a
draft. There will also be a button to generate and send the email.

##Implementation
###Model
* DutyLogTemplate.swift
* DutyLog.swift
* SendLog.swift

###View
* DutyLogsTableView
* NewDutyLogView
* NewDutyLogTemplateView
* DefaultsView

###Controller
* DutyLogsTableViewController
* NewDutyLogViewController
* NewDutyLogTemplateViewController
* DefaultsViewController