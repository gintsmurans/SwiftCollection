//
//  EUIColor.swift
//
//  Created by Gints Murans on 03/11/14.
//  Copyright (c) 2014 Gints Murans. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    /// Initializes and returns a color object using the specified opacity and RGB component values, but instead of 0.0-1.0 this method takes 0-255 values making it easier to setup UIColor from photoshop/gimp/etc color panel.
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
}
