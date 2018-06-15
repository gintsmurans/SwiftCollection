//
//  CUIButton.swift
//
//  Created by Gints Murans on 19.08.16.
//  Copyright © 2016 Gints Murans. All rights reserved.
//

import UIKit

/**
 CUIButton - Custom UIButton allowing to set background colors depending on the state of the button.
 Colors can be set via interface builder.
 */
@IBDesignable
open class CUIButton: UIButton {

    fileprivate var originalBackgroundColor: UIColor?


    override public init(frame: CGRect) {
        super.init(frame: frame)

        self.originalBackgroundColor = self.backgroundColor
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.originalBackgroundColor = self.backgroundColor
    }


    func handleButtonStatusChange() {
        if self.isEnabled == false {
            self.backgroundColor = self.disabledBackgroundColor
            return
        }

        if self.isHighlighted {
            self.backgroundColor = self.highlightedBackgroundColor
            return
        }

        if self.isSelected {
            self.backgroundColor = self.selectedBackgroundColor
            return
        }

        self.backgroundColor = self.originalBackgroundColor
    }


    // MARK: - Highlighted

    @IBInspectable open var highlightedBackgroundColor: UIColor = UIColor.clear {
        didSet {
            if self.isHighlighted {
                self.backgroundColor = highlightedBackgroundColor
            }
        }
    }

    open override var isHighlighted: Bool {
        didSet {
            self.handleButtonStatusChange()
        }
    }


    // MARK: - Selected

    @IBInspectable open var selectedBackgroundColor: UIColor = UIColor.clear {
        didSet {
            if self.isSelected {
                self.backgroundColor = selectedBackgroundColor
            }
        }
    }

    open override var isSelected: Bool {
        didSet {
            self.handleButtonStatusChange()
        }
    }


    // MARK: - Disabled

    @IBInspectable open var disabledBackgroundColor: UIColor = UIColor.clear {
        didSet {
            if self.isEnabled == false {
                self.backgroundColor = disabledBackgroundColor
            }
        }
    }

    open override var isEnabled: Bool {
        didSet {
            self.handleButtonStatusChange()
        }
    }
}
