//
//  FKCalendarView.swift
//  FKCalendarView
//
//  Created by Kazuya Ueoka on 2016/05/27.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit

public enum FKCalendarViewWeekday: Int
{
    case Sunday = 0
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
}

public protocol FKCalendarViewDelegate: class
{
    func dequeueReusableWeekdayCellCollectionView(collectionView: UICollectionView, indexPath: NSIndexPath, weekDay: FKCalendarViewWeekday) -> UICollectionViewCell
    func dequeueReusableDateCellWithCollectionView(collectionView: UICollectionView, indexPath: NSIndexPath, date: NSDate) -> UICollectionViewCell
    func calendarView(calendarView: FKCalendarView, didSelectDayCell cell: UICollectionViewCell, date: NSDate) -> Void
}

public class FKCalendarViewLayout: UICollectionViewFlowLayout
{
    private static let numberOfWeekDays: CGFloat = 7.0
    public var margin: CGFloat = 2.0 {
        didSet {
            self.minimumLineSpacing = self.margin
            self.minimumInteritemSpacing = self.margin
            self.sectionInset = UIEdgeInsets(top: self.margin, left: 0.0, bottom: 0.0, right: 0.0)
        }
    }
    
    public var frame: CGRect = CGRect.zero {
        didSet {
            let size :CGFloat = ((self.frame.width - self.dynamicType.numberOfWeekDays) / self.dynamicType.numberOfWeekDays)
            self.itemSize = CGSize(width: size - self.margin, height:size - self.margin)
        }
    }
    
    public convenience init(frame: CGRect, margin: CGFloat)
    {
        self.init()
        
        defer {
            self.margin = margin
            self.frame = frame
        }
    }
}

public class FKCalendarView: UICollectionView
{
    public var date: NSDate = NSDate() {
        didSet
        {
            let calendar: NSCalendar = NSCalendar.sharedCalendar
            let components: NSDateComponents = calendar.components([.Year, .Month, .Day], fromDate: self.date)
            self.year = components.year
            self.month = components.month
            self.day = components.day
            self.numberOfWeeks = self.date.numberOfWeeks
            self.numberOfDays = self.date.numberOfDays
        }
    }
    private (set) public lazy var year: Int = {
        let calenndar: NSCalendar = NSCalendar.sharedCalendar
        return calenndar.component(NSCalendarUnit.Year, fromDate: self.date)
    }()
    
    private (set) public lazy var month: Int = {
        let calenndar: NSCalendar = NSCalendar.sharedCalendar
        return calenndar.component(NSCalendarUnit.Month, fromDate: self.date)
    }()
    
    private (set) public lazy var day: Int = {
        let calenndar: NSCalendar = NSCalendar.sharedCalendar
        return calenndar.component(NSCalendarUnit.Day, fromDate: self.date)
    }()
    private (set) public var numberOfWeeks :Int = 0
    private (set) public var numberOfDays :Int = 0
    public var calendarDelegate: FKCalendarViewDelegate?
    public var weekdayHeight: CGFloat = 32.0
    
    public convenience init(frame: CGRect, date: NSDate)
    {
        let layout: FKCalendarViewLayout = FKCalendarViewLayout(frame: frame, margin: 6.0)
        self.init(frame: frame, collectionViewLayout: layout)
        
        defer {
            self.date = date
            self.backgroundColor = UIColor.whiteColor()
            self.dataSource = self
            self.delegate = self
        }
    }
    private override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public override var frame: CGRect {
        didSet {
            if let layout: FKCalendarViewLayout = self.collectionViewLayout as? FKCalendarViewLayout {
                layout.frame = self.bounds
            }
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }
}

extension FKCalendarView: UICollectionViewDataSource
{
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.numberOfWeeks + 1
    }
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(FKCalendarViewLayout.numberOfWeekDays)
    }
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        if 0 == indexPath.section
        {
            guard let weekday: FKCalendarViewWeekday = FKCalendarViewWeekday(rawValue: indexPath.row) else
            {
                fatalError("FKCalendarViewWeekday initialize failed")
            }
            guard let weekdayCell: UICollectionViewCell = self.calendarDelegate?.dequeueReusableWeekdayCellCollectionView(self, indexPath: indexPath, weekDay: weekday) else
            {
                fatalError("FKCalendarWeekdayCell")
            }
            cell = weekdayCell
        } else
        {
            guard let date: NSDate = self.date.dateFromIndexPath(indexPath) else
            {
                fatalError("date initialize failed.")
            }
            guard let dateCell: UICollectionViewCell = self.calendarDelegate?.dequeueReusableDateCellWithCollectionView(self, indexPath: indexPath, date: date) else
            {
                fatalError("cell initialize failed.")
            }
            cell = dateCell
        }
        return cell
    }
}

extension FKCalendarView: UICollectionViewDelegate {
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if 0 == indexPath.section
        {
            return
        }
        
        guard let cell: UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath) else
        {
            return
        }
        
        guard let date: NSDate = self.date.dateFromIndexPath(indexPath) else
        {
            return
        }
        self.calendarDelegate?.calendarView(self, didSelectDayCell: cell, date: date)
    }
}
extension FKCalendarView: UICollectionViewDelegateFlowLayout
{
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        guard let layout: FKCalendarViewLayout = collectionView.collectionViewLayout as? FKCalendarViewLayout else
        {
            fatalError("FKCalendarViewLayout get failed")
        }
        
        if 0 == indexPath.section
        {
            var size: CGSize = layout.itemSize
            size.height = self.weekdayHeight
            return size
        }
        return layout.itemSize
    }
}
