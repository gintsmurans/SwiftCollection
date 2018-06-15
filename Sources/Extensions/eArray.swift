//
//  EArray.swift
//
//  Created by Gints Murans on 03.11.14.
//  Copyright © 2014 Gints Murans. All rights reserved.
//

import Foundation

public extension Array {
    mutating func removeObject<U: Equatable>(_ object: U) -> Int? {
        var index: Int?
        for (idx, objectToCompare) in self.enumerated() {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }

        if index != nil {
            self.remove(at: index!)
        }
        return index
    }

    public func replaceNull(with newItem: Any, doRecursive recursive: Bool = true) -> Array<Any> {
        var dict = self.filter {
            return !($0 is NSNull)
        }

        if recursive == true {
            for (key, item) in dict.enumerated() {
                if let tmpItem = item as? [String: Any?] {
                    dict[key] = tmpItem.replaceNull(with: "") as! Element
                }
            }
        }

        return dict
    }
}


public extension Sequence {
    func categorise<T: Hashable>(_ key: (Iterator.Element) -> T) -> [T: [Iterator.Element]] {
        var dict: [T: [Iterator.Element]] = [:]
        for el in self {
            let key = key(el)
            if case nil = dict[key]?.append(el) {
                dict[key] = [el]
            }
        }
        return dict
    }

    // Returns json string constructed from this array or nil in case of an error
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
