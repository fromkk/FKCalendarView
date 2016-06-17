//
//  View.swift
//  FKCalendarViewSample
//
//  Created by Kazuya Ueoka on 2016/05/28.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit

public class FKCalendarWeekdayCell: UICollectionViewCell
{
    public static let cellIdentifier: String = "FKCalendarWeekdayCell"
    public lazy var weekLabel: UILabel = {
        let result: UILabel = UILabel()
        result.textAlignment = NSTextAlignment.center
        result.font = UIFont(name: "Avenir-Bold", size: 12.0)
        result.textColor = UIColor(white: 0.25, alpha: 1.0)
        return result
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        self.contentView.addSubview(self.weekLabel)
        self.layer.cornerRadius = 6.0
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.weekLabel.frame = self.bounds
    }
}

public class FKCalendarDateCell: UICollectionViewCell
{
    public static let cellIdentifier: String = "FKCalendarDateCell"
    public lazy var dateLabel: UILabel = {
        let result: UILabel = UILabel()
        result.textAlignment = NSTextAlignment.center
        result.font = UIFont(name: "Avenir-Bold", size: 12.0)
        result.textColor = UIColor(white: 0.1, alpha: 1.0)
        return result
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.dateLabel)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.dateLabel.frame = self.bounds
    }
}

