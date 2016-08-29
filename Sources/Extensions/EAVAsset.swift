//
//  EAVAsset.swift
//
//  Created by Gints Murans on 03.11.14.
//  Copyright © 2014 Gints Murans. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

public extension AVAsset {
    /// Class method that returns instance of UIImage containing first frame of video asset loaded from the url specified by "url" parameter
    class func firstVideoFrameFromURL(url: NSURL!) -> UIImage? {
        let asset = AVAsset(URL: url)
        return asset.firstVideoFrame()
    }

    /// Returns instance of UIImage containing first frame of current video asset
    func firstVideoFrame() -> UIImage? {
        let time = CMTimeMake(1, 1)
        return self.videoFrameAt(Time: time)
    }

    /// Returns instance of UIImage containing frame at time specified by "seconds" parameter
    func videoFrameAt(Seconds seconds: Float64) -> UIImage? {
        let time = CMTimeMake(Int64(24 * seconds), 24)
        return self.videoFrameAt(Time: time)
    }

    /// Returns instance of UIImage containing frame at time specified by "time" parameter
    func videoFrameAt(Time time: CMTime) -> UIImage? {
        let assetImageGemerator = AVAssetImageGenerator(asset: self)
        assetImageGemerator.appliesPreferredTrackTransform = true

        var frameRef: CGImage?
        do {
            frameRef = try assetImageGemerator.copyCGImageAtTime(time, actualTime: nil)
        }
        catch ( _) {
            return nil
        }

        return UIImage(CGImage: frameRef!)
    }
}
