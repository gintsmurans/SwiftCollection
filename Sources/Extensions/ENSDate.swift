//
//  ENSDate.swift
//  Pods
//
//  Created by Gints Murans on 01.09.16.
//
//

import Foundation

public extension NSDate {
    var dateComponents: NSDateComponents {
        get {
            let unitFlags: NSCalendarUnit = [.Hour, .Minute, .Second, .Day, .Month, .Year]
            return NSCalendar.currentCalendar().components(unitFlags, fromDate: self)
        }
    }

    func format(format: String) -> String {
        var formatter = NSDateFormatter()
        formatter.dateFormat = format

        return formatter.stringFromDate(self)
    }
}
