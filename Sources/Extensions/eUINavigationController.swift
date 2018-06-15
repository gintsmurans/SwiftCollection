//
//  EUINavigationController.swift
//
//  Created by Gints Murans on 29.08.16.
//  Copyright © 2016 Gints Murans. All rights reserved.
//

import UIKit

public extension UINavigationController {
    func popViewControllerAnimatedWithHandler(_ handler: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(handler)
        self.popViewController(animated: true)
        CATransaction.commit()
    }
}
