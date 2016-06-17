//
//  FKCalendarView.swift
//  FKCalendarView
//
//  Created by Kazuya Ueoka on 2016/05/27.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit

@objc public enum FKCalendarViewWeekday: Int {
    case sunday = 0
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}

internal class FKCalendarViewReusableView: UICollectionReusableView {
    static let viewIdentifier: String = "FKCalendarViewReusableView"
}

@objc public protocol FKCalendarViewDelegate: class {
    func dequeueReusableWeekdayCellWithCalendarView(_ calendarView: FKCalendarView, indexPath: IndexPath, weekDay: FKCalendarViewWeekday) -> UICollectionViewCell
    func dequeueReusableDateCellWithCalendarView(_ calendarView: FKCalendarView, indexPath: IndexPath, date: Date) -> UICollectionViewCell
    func calendarView(_ calendarView: FKCalendarView, didSelectDayCell cell: UICollectionViewCell, date: Date) -> Void
    @objc optional func dequeueReusableSectionHeaderWithCalendarView(_ calendarView: FKCalendarView, indexPath: IndexPath) -> UICollectionReusableView
    @objc optional func dequeueReusableSectionFooterWithCalendarView(_ calendarView: FKCalendarView, indexPath: IndexPath) -> UICollectionReusableView
    @objc optional func sectionHeaderSizeWithCalendarView(_ calendarView: FKCalendarView, section: Int) -> CGSize
    @objc optional func sectionFooterSizeWithCalendarView(_ calendarView: FKCalendarView, section: Int) -> CGSize
}

public class FKCalendarViewLayout: UICollectionViewFlowLayout {
    private static let numberOfWeekDays: CGFloat = 7.0
    public var margin: CGFloat = 2.0 {
        didSet {
            self.minimumLineSpacing = self.margin
            self.minimumInteritemSpacing = self.margin
            self.sectionInset = UIEdgeInsets(top: self.margin / 2.0, left: 0.0, bottom: self.margin / 2.0, right: 0.0)
        }
    }

    public var frame: CGRect = CGRect.zero {
        didSet {
            let size: CGFloat = ((self.frame.width - self.dynamicType.numberOfWeekDays) / self.dynamicType.numberOfWeekDays)
            self.itemSize = CGSize(width: size - self.margin, height:size - self.margin)
        }
    }

    public convenience init(frame: CGRect, margin: CGFloat) {
        self.init()

        defer {
            self.margin = margin
            self.frame = frame
        }
    }
}

public class FKCalendarView: UICollectionView {
    public var date: Date = Date() {
        didSet {
            let calendar: Calendar = Calendar.sharedCalendar
            let components: DateComponents = calendar.components([.year, .month, .day], from: self.date)
            self.year = components.year!
            self.month = components.month!
            self.day = components.day!
            self.numberOfWeeks = self.date.numberOfWeeks
            self.numberOfDays = self.date.numberOfDays
        }
    }
    private (set) public lazy var year: Int = {
        let calenndar: Calendar = Calendar.sharedCalendar
        return calenndar.component(Calendar.Unit.year, from: self.date)
    }()

    private (set) public lazy var month: Int = {
        let calenndar: Calendar = Calendar.sharedCalendar
        return calenndar.component(Calendar.Unit.month, from: self.date)
    }()

    private (set) public lazy var day: Int = {
        let calenndar: Calendar = Calendar.sharedCalendar
        return calenndar.component(Calendar.Unit.day, from: self.date)
    }()
    private (set) public var numberOfWeeks :Int = 0
    private (set) public var numberOfDays :Int = 0
    public var calendarDelegate: FKCalendarViewDelegate?
    public var weekdayHeight: CGFloat = 32.0

    public convenience init(frame: CGRect, date: Date) {
        let layout: FKCalendarViewLayout = FKCalendarViewLayout(frame: frame, margin: 6.0)
        self.init(frame: frame, collectionViewLayout: layout)

        self.register(FKCalendarViewReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: FKCalendarViewReusableView.viewIdentifier)
        self.register(FKCalendarViewReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: FKCalendarViewReusableView.viewIdentifier)
        defer {
            self.date = date
            self.backgroundColor = UIColor.white()
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

extension FKCalendarView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.numberOfWeeks + 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(FKCalendarViewLayout.numberOfWeekDays)
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        if 0 == (indexPath as NSIndexPath).section {
            guard let weekday: FKCalendarViewWeekday = FKCalendarViewWeekday(rawValue: (indexPath as NSIndexPath).row) else {
                fatalError("FKCalendarViewWeekday initialize failed")
            }
            guard let weekdayCell: UICollectionViewCell = self.calendarDelegate?.dequeueReusableWeekdayCellWithCalendarView(self, indexPath: indexPath, weekDay: weekday) else {
                fatalError("FKCalendarWeekdayCell")
            }
            cell = weekdayCell
        } else {
            guard let date: Date = self.date.dateFromIndexPath(indexPath) else {
                fatalError("date initialize failed.")
            }
            guard let dateCell: UICollectionViewCell = self.calendarDelegate?.dequeueReusableDateCellWithCalendarView(self, indexPath: indexPath, date: date) else {
                fatalError("cell initialize failed.")
            }
            cell = dateCell
        }
        return cell
    }
}

extension FKCalendarView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if 0 == (indexPath as NSIndexPath).section {
            return
        }

        guard let cell: UICollectionViewCell = collectionView.cellForItem(at: indexPath) else {
            return
        }

        guard let date: Date = self.date.dateFromIndexPath(indexPath) else {
            return
        }
        self.calendarDelegate?.calendarView(self, didSelectDayCell: cell, date: date)
    }

    @objc(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            guard let result: UICollectionReusableView = self.calendarDelegate?.dequeueReusableSectionHeaderWithCalendarView?(self, indexPath: indexPath) else {
                return FKCalendarViewReusableView()
            }
            return result
        } else if kind == UICollectionElementKindSectionFooter {
            guard let result: UICollectionReusableView = self.calendarDelegate?.dequeueReusableSectionFooterWithCalendarView?(self, indexPath: indexPath) else {
                return FKCalendarViewReusableView()
            }
            return result
        }
        return FKCalendarViewReusableView()
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let result: CGSize = self.calendarDelegate?.sectionHeaderSizeWithCalendarView?(self, section: section) else {
            return CGSize.zero
        }
        return result
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let result: CGSize = self.calendarDelegate?.sectionFooterSizeWithCalendarView?(self, section: section) else {
            return CGSize.zero
        }
        return result
    }
}
extension FKCalendarView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout: FKCalendarViewLayout = collectionView.collectionViewLayout as? FKCalendarViewLayout else {
            fatalError("FKCalendarViewLayout get failed")
        }

        if 0 == (indexPath as NSIndexPath).section {
            var size: CGSize = layout.itemSize
            size.height = self.weekdayHeight
            return size
        }
        return layout.itemSize
    }
}
