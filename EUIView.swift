//
//  EUIView.swift
//  DDZ Dienas Atskaite
//
//  Created by Gints Murans on 29.08.16.
//  Copyright © 2016. g. 4Apps. All rights reserved.
//

import UIKit

public extension UIView {
    
    func viewWithTagRecursive(tag: Int) -> UIView? {
        if let view = self.viewWithTag(tag) {
            return view
        }

        for item in self.subviews {
            if let view = item.viewWithTagRecursive(tag) {
                return view
            }
        }

        return nil
    }
}
