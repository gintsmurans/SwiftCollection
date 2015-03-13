//
//  EUIImage.swift
//
//  Created by Gints Murans on 13/03/15.
//  Copyright (c) 2015 Gints Murans. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    /// Initializes a image object using the specified color as background color and size as a size for the image
    convenience init?(color: UIColor, size: CGSize) {
            var rect = CGRectMake(0, 0, size.width, size.height)
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            color.setFill()
            UIRectFill(rect)
            var image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            self.init(CGImage: image.CGImage)
    }
}
