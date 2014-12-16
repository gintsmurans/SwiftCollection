//
//  EAVAsset.swift
//
//  Created by Gints Murans on 03/11/14.
//  Copyright (c) 2014 Gints Murans. All rights reserved.
//

import Foundation
import AVFoundation

extension AVAsset {
    /// Class method that returns instance of UIImage containing first frame of video asset loaded from the url specified by "url" parameter
    class func firstVideoFrameFromURL(url: NSURL!) -> UIImage? {
        let asset = AVAsset.assetWithURL(url) as AVAsset
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
        let frameRef = assetImageGemerator.copyCGImageAtTime(time, actualTime: nil, error: nil)

        return UIImage(CGImage: frameRef)
    }
}
