//
//  UITextViewFixed.swift
//  Castle
//
//  Created by Gints Murans on 04/10/2018.
//  Copyright © 2018 4Apps. All rights reserved.
//

import UIKit

@IBDesignable class ExtendedUITextView: UITextView {

    @IBInspectable public var bottomInset: CGFloat {
        get { return customInsets.bottom }
        set { customInsets.bottom = newValue }
    }
    @IBInspectable public var leftInset: CGFloat {
        get { return customInsets.left }
        set { customInsets.left = newValue }
    }
    @IBInspectable public var rightInset: CGFloat {
        get { return customInsets.right }
        set { customInsets.right = newValue }
    }
    @IBInspectable public var topInset: CGFloat {
        get { return customInsets.top }
        set { customInsets.top = newValue }
    }
    public var customInsets: UIEdgeInsets = UIEdgeInsets.zero

    @IBInspectable public var maxCharacters: Int = 0

    @IBInspectable public var cornerRadius: CGFloat = 0.0
    @IBInspectable public var borderWidth: CGFloat = 0.0
    @IBInspectable public var borderColor: UIColor?


    override func layoutSubviews() {
        super.layoutSubviews()

        textContainerInset = customInsets
        textContainer.lineFragmentPadding = 0

        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        if let borderColor = borderColor {
            layer.borderColor = borderColor.cgColor
        }
    }
}
