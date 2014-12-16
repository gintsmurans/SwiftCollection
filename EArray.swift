//
//  EArray.swift
//
//  Created by Gints Murans on 03/11/14.
//  Copyright (c) 2014 Gints Murans. All rights reserved.
//

import Foundation

extension Array {
    mutating func removeObject<U: Equatable>(object: U) -> Int? {
        var index: Int?
        for (idx, objectToCompare) in enumerate(self) {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }

        if index != nil {
            self.removeAtIndex(index!)
        }
        return index
    }
}
