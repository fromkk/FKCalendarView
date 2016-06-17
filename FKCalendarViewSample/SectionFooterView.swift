//
//  SectionFooterView.swift
//  FKCalendarViewSample
//
//  Created by Kazuya Ueoka on 2016/05/29.
//  Copyright © 2016年 fromKK. All rights reserved.
//

import UIKit

internal class SectionFooter: FKCalendarViewReusableView
{
    static let footerIdentifier: String = "SectionHeader"
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("FKCalendarViewReusableView must be initialize with init(frame:)")
    }
}
