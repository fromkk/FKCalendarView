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
        case .Sunday:
            return "Sun"
        case .Monday:
            return "Mon"
        case .Tuesday:
            return "Tue"
        case .Wednesday:
            return "Wed"
        case .Thursday:
            return "Tur"
        case .Friday:
            return "Fri"
        case .Saturday:
            return "Sat"
        }
    }
}

class ViewController: UIViewController {
    
    lazy var date: NSDate = {
        let comps: NSDateComponents = NSDateComponents()
        comps.year = 2016
        comps.month = 1
        comps.day = 1
        guard let date: NSDate = NSCalendar.sharedCalendar.dateFromComponents(comps) else
        {
            fatalError("date get failed")
        }
        return date
    }()
    lazy var calendarView: FKCalendarView = {
        let result: FKCalendarView = FKCalendarView(frame: self.view.bounds, date: self.date)
        result.calendarDelegate = self
        result.registerClass(FKCalendarWeekdayCell.self, forCellWithReuseIdentifier: FKCalendarWeekdayCell.cellIdentifier)
        result.registerClass(FKCalendarDateCell.self, forCellWithReuseIdentifier: FKCalendarDateCell.cellIdentifier)
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
    func dequeueReusableWeekdayCellCollectionView(collectionView: UICollectionView, indexPath: NSIndexPath, weekDay: FKCalendarViewWeekday) -> UICollectionViewCell {
        guard let cell: FKCalendarWeekdayCell = collectionView.dequeueReusableCellWithReuseIdentifier(FKCalendarWeekdayCell.cellIdentifier, forIndexPath: indexPath) as? FKCalendarWeekdayCell else
        {
            fatalError("FKCalendarViewWeekday initialize failed")
        }
        cell.weekLabel.text = weekDay.toString()
        return cell
    }
    
    func dequeueReusableDateCellWithCollectionView(collectionView: UICollectionView, indexPath: NSIndexPath, date: NSDate) -> UICollectionViewCell {
        guard let cell: FKCalendarDateCell = collectionView.dequeueReusableCellWithReuseIdentifier(FKCalendarDateCell.cellIdentifier, forIndexPath: indexPath) as? FKCalendarDateCell else
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
    
    func calendarView(calendarView: FKCalendarView, didSelectDayCell cell: UICollectionViewCell, date: NSDate) {
        print(date)
    }
}
