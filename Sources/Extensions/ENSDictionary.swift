//
//  EDictionary.swift
//
//  Created by Gints Murans on 03.11.14.
//  Copyright © 2014 Gints Murans. All rights reserved.
//

import Foundation

public extension NSDictionary {
    // Returns json string constructed from this dictionary or nil in case of an error
    func jsonString(pretty: Bool = false) -> (String?, String?) {
        if NSJSONSerialization.isValidJSONObject(self) == false {
            return (nil, "Not valid JSON object")
        }

        var jsonData: NSData?
        do {
            let options = (pretty == true ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions())
            try jsonData = NSJSONSerialization.dataWithJSONObject(self, options: options)
        } catch let error as NSError {
            return (nil, error.localizedDescription)
        }

        if let tmp = String(data: jsonData!, encoding: NSUTF8StringEncoding) {
            return (tmp, nil)
        } else {
            return ("{}", nil)
        }
    }

    convenience init?(jsonString: String) {
        guard let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) else {
            return nil
        }

        var newObject: NSDictionary?
        do {
            newObject = try NSJSONSerialization.JSONObjectWithData(data, options: [NSJSONReadingOptions.MutableLeaves, NSJSONReadingOptions.MutableContainers]) as? NSDictionary
        } catch {
            return nil
        }

        self.init(dictionary: newObject!)
    }
}
