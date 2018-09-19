//
//  EDictionary.swift
//
//  Created by Gints Murans on 03.11.14.
//  Copyright © 2014 Gints Murans. All rights reserved.
//

import Foundation

public extension NSDictionary {
    // Returns json string constructed from this dictionary or nil in case of an error
    func jsonString(_ pretty: Bool = false) -> (String?, String?) {
        if JSONSerialization.isValidJSONObject(self) == false {
            return (nil, "Not valid JSON object")
        }

        var jsonData: Data?
        do {
            let options = (pretty == true ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions())
            try jsonData = JSONSerialization.data(withJSONObject: self, options: options)
        } catch let error as NSError {
            return (nil, error.localizedDescription)
        }

        if let tmp = String(data: jsonData!, encoding: String.Encoding.utf8) {
            return (tmp, nil)
        } else {
            return ("{}", nil)
        }
    }

    convenience init?(jsonString: String) {
        guard let data = jsonString.data(using: String.Encoding.utf8) else {
            return nil
        }

        var newObject: NSDictionary?
        do {
            newObject = try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.mutableLeaves, JSONSerialization.ReadingOptions.mutableContainers]) as? NSDictionary
        } catch {
            return nil
        }

        self.init(dictionary: newObject!)
    }
}

public extension Dictionary {
    // Returns json string constructed from this dictionary or nil in case of an error
    func jsonString(_ pretty: Bool = false) -> (String?, String?) {
        if JSONSerialization.isValidJSONObject(self) == false {
            return (nil, "Not valid JSON object")
        }

        var jsonData: Data?
        do {
            let options = (pretty == true ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions())
            try jsonData = JSONSerialization.data(withJSONObject: self, options: options)
        } catch let error as NSError {
            return (nil, error.localizedDescription)
        }

        if let tmp = String(data: jsonData!, encoding: String.Encoding.utf8) {
            return (tmp, nil)
        } else {
            return ("{}", nil)
        }
    }
}


extension Dictionary where Key == String, Value == Any? {
    public func replaceNull(with newItem: Any, doRecursive recursive: Bool = true) -> [String: Any?] {
        var dict: [String: Any?] = self.mapValues { $0 is NSNull || $0 == nil ? newItem : $0 }

        if recursive == true {
            for (key, item) in dict {
                if let tmpItem = item as? [String: Any?] {
                    dict[key] = tmpItem.replaceNull(with: newItem)
                } else if let tmpItem = item as? [[String: Any?]] {
                    dict[key] = tmpItem.replaceNull(with: newItem)
                }
            }
        }

        return dict
    }
}
