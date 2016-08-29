//
//  ENSBundle.swift
//
//  Created by Gints Murans on 17/12/14.
//  Copyright (c) 2014 Gints Murans. All rights reserved.
//

import Foundation

extension NSBundle {
    func pathForResource(filename: String) -> String? {
        if self.resourcePath == nil {
            return nil
        }

        let path_to_file = "\(self.resourcePath!)/\(filename)"
        if NSFileManager.defaultManager().fileExistsAtPath(path_to_file) {
            return path_to_file
        }

        return nil
    }
}
