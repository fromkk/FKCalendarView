//
//  ViewController.swift
//  FKCalendarViewSample
//
//  Created by Kazuya Ueoka on 2016/05/27.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit

extension FKCalendarViewWeekday
{
    func toString() -> String
    {
        switch self
        {
        case .sunday:
            return "Sun"
        case .monday:
            return "Mon"
        case .tuesday:
            return "Tue"
        case .wednesday:
            return "Wed"
        case .thursday:
            return "Tur"
        case .friday:
            return "Fri"
        case .saturday:
            return "Sat"
        }
    }
}

class ViewController: UIViewController {
    
    lazy var date: Date = {
        var comps: DateComponents = DateComponents()
        comps.year = 2016
        comps.month = 6
        comps.day = 1
        guard let date: Date = Calendar.sharedCalendar.date(from: comps) else
        {
            fatalError("date get failed")
        }
        return date
    }()
    lazy var calendarView: FKCalendarView = {
        let result: FKCalendarView = FKCalendarView(frame: self.view.bounds, date: self.date)
        result.calendarDelegate = self
        result.register(FKCalendarWeekdayCell.self, forCellWithReuseIdentifier: FKCalendarWeekdayCell.cellIdentifier)
        result.register(FKCalendarDateCell.self, forCellWithReuseIdentifier: FKCalendarDateCell.cellIdentifier)
        result.register(SectionFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: SectionFooter.footerIdentifier)
        return result
    }()
    
    override func loadView() {
        super.loadView()
        
        self.title = "\(self.date.year)/\(self.date.month)"
        self.view.addSubview(self.calendarView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.calendarView.frame = self.view.bounds
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: FKCalendarViewDelegate
{
    func dequeueReusableWeekdayCellWithCalendarView(_ calendarView: FKCalendarView, indexPath: IndexPath, weekDay: FKCalendarViewWeekday) -> UICollectionViewCell {
        guard let cell: FKCalendarWeekdayCell = calendarView.dequeueReusableCell(withReuseIdentifier: FKCalendarWeekdayCell.cellIdentifier, for: indexPath) as? FKCalendarWeekdayCell else
        {
            fatalError("FKCalendarViewWeekday initialize failed")
        }
        cell.weekLabel.text = weekDay.toString()
        return cell
    }
    func dequeueReusableDateCellWithCalendarView(_ calendarView: FKCalendarView, indexPath: IndexPath, date: Date) -> UICollectionViewCell {
        guard let cell: FKCalendarDateCell = calendarView.dequeueReusableCell(withReuseIdentifier: FKCalendarDateCell.cellIdentifier, for: indexPath) as? FKCalendarDateCell else
        {
            fatalError("FKCalendarDateCell initialize failed")
        }
        cell.dateLabel.text = String(date.day)
        if date.month != self.date.month
        {
            cell.dateLabel.textColor = UIColor(white: 0.75, alpha: 1.0)
        } else
        {
            cell.dateLabel.textColor = UIColor(white: 0.25, alpha: 1.0)
        }
        return cell
    }
    func dequeueReusableSectionFooterWithCalendarView(_ calendarView: FKCalendarView, indexPath: IndexPath) -> UICollectionReusableView {
        guard let footer: SectionFooter = calendarView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: SectionFooter.footerIdentifier, for: indexPath) as? SectionFooter else
        {
            return SectionFooter()
        }
        return footer
    }
    func sectionFooterSizeWithCalendarView(_ calendarView: FKCalendarView, section: Int) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: 1.0)
    }
    
    func calendarView(_ calendarView: FKCalendarView, didSelectDayCell cell: UICollectionViewCell, date: Date) {
        print(date)
    }
}
