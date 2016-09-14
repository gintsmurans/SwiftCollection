//
//  ENSBundle.swift
//
//  Created by Gints Murans on 17.12.14.
//  Copyright © 2014 Gints Murans. All rights reserved.
//

import Foundation

public extension Bundle {
    func pathForResource(_ filename: String) -> String? {
        if self.resourcePath == nil {
            return nil
        }

        let path_to_file = "\(self.resourcePath!)/\(filename)"
        if FileManager.default.fileExists(atPath: path_to_file) {
            return path_to_file
        }

        return nil
    }
}
