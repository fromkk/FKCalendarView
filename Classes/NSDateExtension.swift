//
//  NSDateExtension.swift
//  FKCalendarView
//
//  Created by Kazuya Ueoka on 2016/05/27.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import Foundation

internal extension Calendar
{
    static var sharedCalendar: Calendar {
        let calendar: Calendar = Calendar.current()
        calendar.locale = Locale.system()
        calendar.timeZone = TimeZone.system()
        return calendar
    }
}

internal extension Date
{
    var numberOfDays: Int
    {
        let calendar: Calendar = Calendar.sharedCalendar
        var comp: DateComponents = calendar.components([.year, .month, .day], from: self)
        comp.month? += 1
        comp.day = 0
        
        guard let date = calendar.date(from: comp) else
        {
            return 0
        }
        return calendar.component(.day, from: date)
    }
    var numberOfWeeks: Int
    {
        let calendar: Calendar = Calendar.sharedCalendar
        var comp: DateComponents = calendar.components([.year, .month, .day], from: self)
        comp.month? += 1
        comp.day = 0
        
        guard let date = calendar.date(from: comp) else
        {
            return 0
        }
        return calendar.component(.weekOfMonth, from: date)
    }
    func dateFromIndexPath(_ indexPath: IndexPath) -> Date? {
        let calendar :Calendar = Calendar.sharedCalendar
        
        let comp1 :DateComponents = calendar.components([.year, .month], from: self)
        var comp2 :DateComponents = DateComponents()
        comp2.weekOfMonth = (indexPath as NSIndexPath).section
        comp2.weekday     = (indexPath as NSIndexPath).row + 1
        comp2.year        = comp1.year
        comp2.month       = comp1.month
        return calendar.date(from: comp2)
    }
}

public extension Date
{
    var year: Int
    {
        let calendar: Calendar = Calendar.sharedCalendar
        return calendar.component(Calendar.Unit.year, from: self)
    }
    var month: Int
    {
        let calendar: Calendar = Calendar.sharedCalendar
        return calendar.component(Calendar.Unit.month, from: self)
    }
    var day: Int
    {
        let calendar: Calendar = Calendar.sharedCalendar
        return calendar.component(Calendar.Unit.day, from: self)
    }
}
