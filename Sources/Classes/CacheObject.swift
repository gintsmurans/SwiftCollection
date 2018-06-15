//
//  Cache.swift
//
//  Created by Gints Murans on 28.04.2017.
//  Copyright © 2017. g. 4Apps. All rights reserved.
//

import Foundation


struct CacheObject {
    var name: String
    var timeout: Int = 86400
    var items: Any?
    internal var timestamp: Date = Date()

    init(name cacheName: String, timeout cacheTimeout: Int? = nil) {
        self.name = "Cache_" + cacheName
        if cacheTimeout != nil {
            self.timeout = cacheTimeout!
        }

        self.reload()
    }

    mutating func reload() {
        guard let data = UserDefaults.standard.object(forKey: self.name) as? [String: Any] else {
            return
        }

        self.items = data["items"]
        self.timestamp = (data["timestamp"] as! NSDate) as Date
    }

    mutating func update(_ items: Any?) {
        guard var items = items else {
            self.items = nil

            UserDefaults.standard.removeObject(forKey: self.name)
            UserDefaults.standard.synchronize()
            return
        }

        // Arrays
        if let tmp = items as? [[String: Any?]] {
            items = tmp.replaceNull(with: "")
        }

        // Dictionaries
        if let tmp = items as? [String: Any?] {
            items = tmp.replaceNull(with: "")
        }

        self.items = items
        self.timestamp = Date()

        let saveObject = ["items": self.items!, "timestamp": self.timestamp]
        UserDefaults.standard.set(saveObject, forKey: self.name)
        UserDefaults.standard.synchronize()
    }

    mutating func invalidate(_ force: Bool = false) {
        if force || self.shouldReload() {
            self.update(nil)
        }
    }

    func shouldReload() -> Bool {
        if self.items == nil {
            return true
        }

        if Int(Date().timeIntervalSince(self.timestamp)) >= self.timeout {
            return true
        }

        return false
    }
}
