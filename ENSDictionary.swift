//
//  EDictionary.swift
//  donster.me
//
//  Created by Gints Murans on 03/11/14.
//  Copyright (c) 2014 Gints Murans. All rights reserved.
//

import Foundation

extension NSDictionary {
    /// Returns json string constructed from this dictionary or nil in case of an error
    func jsonString(pretty: Bool = false) -> String! {
        if NSJSONSerialization.isValidJSONObject(self) == false {
            return nil
        }

        var error: NSError? = nil
        var returnString: String? = nil
        let jsonData = NSJSONSerialization.dataWithJSONObject(self, options: (pretty == true ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions.allZeros), error: &error)
        if jsonData != nil {
            returnString = NSString(data: jsonData!, encoding: NSUTF8StringEncoding)
        }

        return (returnString == nil ? "{}" : returnString!)
    }
}
