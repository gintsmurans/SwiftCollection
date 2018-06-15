//
//  PaddedTextField.swift
//  Do More
//
//  Created by Gints Murans on 24.05.2018.
//  Copyright © 2018. g. 4Apps. All rights reserved.
//

import UIKit

class PaddedUITextField: UITextField {

    @IBInspectable open var textPadding: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            // updateView()
        }
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, textPadding)

//        if UIEdgeInsetsEqualToEdgeInsets(textPadding, UIEdgeInsets.zero) {
//            return super.textRect(forBounds: bounds)
//        }
//
//        return CGRect(x: bounds.origin.x + textPadding.left, y: bounds.origin.y + textPadding.top, width: bounds.size.width - textPadding.right, height: bounds.size.height - textPadding.bottom)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, textPadding)
    }
}
