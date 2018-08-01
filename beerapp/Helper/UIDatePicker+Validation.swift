//
//  UIDatePicker+Validation.swift
//  beerapp
//
//  Created by Jonathan Solorzano on 3/14/18.
//  Copyright © 2018 Elaniin. All rights reserved.
//

import UIKit

extension UIDatePicker {
    
    func setYearValidation(year: Int) {
        let currentDate: NSDate = NSDate()
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        calendar.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let components: NSDateComponents = NSDateComponents()
        components.calendar = calendar as Calendar
        components.year = -year
        let maxDate: NSDate = calendar.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        components.year = -150
        let minDate: NSDate = calendar.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        self.minimumDate = minDate as Date
        self.maximumDate = maxDate as Date
    }
}
