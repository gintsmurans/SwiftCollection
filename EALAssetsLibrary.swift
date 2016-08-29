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
    func saveImage(image: UIImage!, toAlbum: String? = nil, withCallback callback: ((error: NSError?) -> Void)?) {
        self.writeImageToSavedPhotosAlbum(image.CGImage, orientation: ALAssetOrientation(rawValue: image.imageOrientation.rawValue)!) { (u, e) -> Void in
            if e != nil {
                if callback != nil {
                    callback!(error: e)
                }
                return
            }

            if toAlbum != nil {
                self.addAssetURL(u, toAlbum: toAlbum!, withCallback: callback)
            }
        }
    }

    func saveVideo(assetUrl: NSURL!, toAlbum: String? = nil, withCallback callback: ((error: NSError?) -> Void)?) {
        self.writeVideoAtPathToSavedPhotosAlbum(assetUrl, completionBlock: { (u, e) -> Void in
            if e != nil {
                if callback != nil {
                    callback!(error: e)
                }
                return;
            }

            if toAlbum != nil {
                self.addAssetURL(u, toAlbum: toAlbum!, withCallback: callback)
            }
        })
    }


    func addAssetURL(assetURL: NSURL!, toAlbum: String!, withCallback callback: ((error: NSError?) -> Void)?) {

        var albumWasFound = false

        // Search all photo albums in the library
        self.enumerateGroupsWithTypes(ALAssetsGroupAlbum, usingBlock: { (group, stop) -> Void in

            // Compare the names of the albums
            if group != nil && toAlbum == group.valueForProperty(ALAssetsGroupPropertyName) as! String {
                albumWasFound = true

                // Get the asset and add to the album
                self.assetForURL(assetURL, resultBlock: { (asset) -> Void in
                    group.addAsset(asset)

                    if callback != nil {
                        callback!(error: nil)
                    }

                }, failureBlock: callback)

                // Album was found, bail out of the method
                return
            }
            else if group == nil && albumWasFound == false {
                // Photo albums are over, target album does not exist, thus create it

                // Create new assets album
                self.addAssetsGroupAlbumWithName(toAlbum, resultBlock: { (group) -> Void in

                    // Get the asset and add to the album
                    self.assetForURL(assetURL, resultBlock: { (asset) -> Void in
                        group.addAsset(asset)

                        if callback != nil {
                            callback!(error: nil)
                        }

                    }, failureBlock: callback)

                }, failureBlock: callback)

                return
            }
        }, failureBlock: callback)
    }
}
