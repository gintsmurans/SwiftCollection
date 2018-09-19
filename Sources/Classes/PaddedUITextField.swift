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
        return bounds.inset(by: textPadding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
}
