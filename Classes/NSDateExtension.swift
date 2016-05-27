//
//  NSDateExtension.swift
//  FKCalendarView
//
//  Created by Kazuya Ueoka on 2016/05/27.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import Foundation

internal extension NSCalendar
{
    static var sharedCalendar: NSCalendar {
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        calendar.locale = NSLocale.systemLocale()
        calendar.timeZone = NSTimeZone.systemTimeZone()
        return calendar
    }
}

internal extension NSDate
{
    var numberOfDays: Int
    {
        let calendar: NSCalendar = NSCalendar.sharedCalendar
        let comp: NSDateComponents = calendar.components([.Year, .Month, .Day], fromDate: self)
        comp.month += 1
        comp.day = 0
        
        guard let date = calendar.dateFromComponents(comp) else
        {
            return 0
        }
        return calendar.component(.Day, fromDate: date)
    }
    var numberOfWeeks: Int
    {
        let calendar: NSCalendar = NSCalendar.sharedCalendar
        let comp: NSDateComponents = calendar.components([.Year, .Month, .Day], fromDate: self)
        comp.month += 1
        comp.day = 0
        
        guard let date = calendar.dateFromComponents(comp) else
        {
            return 0
        }
        return calendar.component(.WeekOfMonth, fromDate: date)
    }
    func dateFromIndexPath(indexPath: NSIndexPath) -> NSDate? {
        let calendar :NSCalendar = NSCalendar.sharedCalendar
        
        let comp1 :NSDateComponents = calendar.components([.Year, .Month], fromDate: self)
        let comp2 :NSDateComponents = NSDateComponents()
        comp2.weekOfMonth = indexPath.section
        comp2.weekday     = indexPath.row + 1
        comp2.year        = comp1.year
        comp2.month       = comp1.month
        return calendar.dateFromComponents(comp2)
    }
}

public extension NSDate
{
    var year: Int
    {
        let calendar: NSCalendar = NSCalendar.sharedCalendar
        return calendar.component(NSCalendarUnit.Year, fromDate: self)
    }
    var month: Int
    {
        let calendar: NSCalendar = NSCalendar.sharedCalendar
        return calendar.component(NSCalendarUnit.Month, fromDate: self)
    }
    var day: Int
    {
        let calendar: NSCalendar = NSCalendar.sharedCalendar
        return calendar.component(NSCalendarUnit.Day, fromDate: self)
    }
}