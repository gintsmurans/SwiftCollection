//
//  EALAssetsLibrary.swift
//
//  Created by Gints Murans on 16.12.14.
//  Copyright © 2014 Gints Murans. All rights reserved.
//

import Foundation
import AssetsLibrary
import UIKit

public extension ALAssetsLibrary {
    func saveImage(_ image: UIImage!, toAlbum: String? = nil, withCallback callback: ((_ error: Error?) -> Void)?) {
        self.writeImage(toSavedPhotosAlbum: image.cgImage, orientation: ALAssetOrientation(rawValue: image.imageOrientation.rawValue)!) { (u, e) -> Void in
            if e != nil {
                if callback != nil {
                    callback!(e as NSError?)
                }
                return
            }

            if toAlbum != nil {
                self.addAssetURL(u, toAlbum: toAlbum!, withCallback: callback)
            }
        }
    }

    func saveVideo(_ assetUrl: URL!, toAlbum: String? = nil, withCallback callback: ((_ error: Error?) -> Void)?) {
        self.writeVideoAtPath(toSavedPhotosAlbum: assetUrl, completionBlock: { (u, e) -> Void in
            if e != nil {
                if callback != nil {
                    callback!(e as NSError?)
                }
                return;
            }

            if toAlbum != nil {
                self.addAssetURL(u, toAlbum: toAlbum!, withCallback: callback)
            }
        })
    }


    func addAssetURL(_ assetURL: URL!, toAlbum: String!, withCallback callback: ((_ error: Error?) -> Void)?) {

        var albumWasFound = false

        // Search all photo albums in the library
        self.enumerateGroupsWithTypes(ALAssetsGroupAlbum, usingBlock: { (group, stop) -> Void in

            // Compare the names of the albums
            if let group = group, let groupProperty = group.value(forProperty: ALAssetsGroupPropertyName) as? String, toAlbum == groupProperty {
                albumWasFound = true

                // Get the asset and add to the album
                self.asset(for: assetURL, resultBlock: { (asset) -> Void in
                    group.add(asset)

                    if callback != nil {
                        callback!(nil)
                    }

                }, failureBlock: callback)

                // Album was found, bail out of the method
                return
            }

            if group == nil && albumWasFound == false {
                // Photo albums are over, target album does not exist, thus create it

                // Create new assets album
                self.addAssetsGroupAlbum(withName: toAlbum, resultBlock: { (group) -> Void in

                    // Get the asset and add to the album
                    self.asset(for: assetURL, resultBlock: { (asset) -> Void in
                        group?.add(asset)

                        if callback != nil {
                            callback!(nil)
                        }

                    }, failureBlock: callback)

                }, failureBlock: callback)

                return
            }

        }, failureBlock: callback)
    }
}
