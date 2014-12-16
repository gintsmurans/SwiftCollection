//
//  EString.swift
//
//  Created by Gints Murans on 03/11/14.
//  Copyright (c) 2014 Gints Murans. All rights reserved.
//

import Foundation

extension String {

    var length: Int {
        get {
            return countElements(self)
        }
    }

    func containsOnly(Chars chars: NSCharacterSet) -> Bool {
        let invalidTimeCharacterSet = chars.invertedSet
        let rangeOfInvalidCharacters = self.rangeOfCharacterFromSet(invalidTimeCharacterSet)
        return (rangeOfInvalidCharacters == nil)
    }

    func substr(start: Int? = nil, length: Int? = nil) -> String? {

        let stringLength = countElements(self)
        var from = 0
        var to = 0

        // Calculate from
        if start < 0 {
            from = stringLength - abs(start!)
        }
        else if start > 0 {
            from = start!
        }

        // Test from, return nil if false
        if from < 0 {
            return nil
        }

        // Calculate to
        if length == nil {
            to = stringLength
        }
        else if length > 0 {
            to = from + length!
        }
        else if length < 0 {
            to = stringLength - abs(length!)
        }

        // Test to, return nil if false
        if to < 0 || to < from || to > stringLength {
            return nil
        }

        // Get the new string
        var new_string = self.substringWithRange(Range<String.Index>(start: advance(self.startIndex, from), end: advance(self.startIndex, to)))
        return new_string
    }

    func isValidEmail(strict: Bool = true) -> Bool {
        // Minimum required characters: a@a.a
        if countElements(self) < 5 {
            return false
        }

        let stricterFilterString = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let laxString = ".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*"
        let emailRegex = strict ? stricterFilterString : laxString
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest!.evaluateWithObject(self)
    }
}
