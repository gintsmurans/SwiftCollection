//
//  ENSDate.swift
//  Pods
//
//  Created by Gints Murans on 01.09.16.
//
//

import Foundation

public extension Date {
    var dateComponents: DateComponents {
        get {
            let unitFlags: NSCalendar.Unit = [.hour, .minute, .second, .day, .month, .year]
            return (Calendar.current as NSCalendar).components(unitFlags, from: self)
        }
    }

    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format

        return formatter.string(from: self)
    }
}
