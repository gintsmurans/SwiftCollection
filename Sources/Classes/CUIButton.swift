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
public class CUIButton: UIButton {

    private var originalBackgroundColor: UIColor?


    override public init(frame: CGRect) {
        super.init(frame: frame)

        self.originalBackgroundColor = self.backgroundColor
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.originalBackgroundColor = self.backgroundColor
    }


    // MARK: - Highlighted

    @IBInspectable public var highlightedBackgroundColor: UIColor = UIColor.clearColor() {
        didSet {
            if self.highlighted {
                self.backgroundColor = highlightedBackgroundColor
            }
        }
    }

    public override var highlighted: Bool {
        didSet {
            if self.highlighted {
                self.backgroundColor = self.highlightedBackgroundColor
            } else {
                self.backgroundColor = self.originalBackgroundColor
            }
        }
    }


    // MARK: - Selected

    @IBInspectable public var selectedBackgroundColor: UIColor = UIColor.clearColor() {
        didSet {
            if self.selected {
                self.backgroundColor = selectedBackgroundColor
            }
        }
    }

    public override var selected: Bool {
        didSet {
            if self.selected {
                if self.originalBackgroundColor == nil {
                    self.originalBackgroundColor = self.backgroundColor
                }
                self.backgroundColor = self.selectedBackgroundColor
            } else {
                self.backgroundColor = self.originalBackgroundColor
            }
        }
    }


    // MARK: - Disabled

    @IBInspectable public var disabledBackgroundColor: UIColor = UIColor.clearColor() {
        didSet {
            if self.enabled == false {
                self.backgroundColor = disabledBackgroundColor
            }
        }
    }

    public override var enabled: Bool {
        didSet {
            if self.enabled == false {
                if self.originalBackgroundColor == nil {
                    self.originalBackgroundColor = self.backgroundColor
                }
                self.backgroundColor = self.selectedBackgroundColor
            } else {
                self.backgroundColor = self.originalBackgroundColor
            }
        }
    }
}
