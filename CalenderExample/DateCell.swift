//
//  File.swift
//  CalenderExample
//
//  Created by Neeraj kumar on 11/07/19.
//  Copyright © 2019 prolifics. All rights reserved.
//

import Foundation
import JTAppleCalendar
class DateCell: JTACDayCell{
    @IBOutlet weak var dateCell: UILabel!
    @IBOutlet weak var dateSelectedView: UIView!
    @IBOutlet weak var selectedDate: UIImageView!
}
