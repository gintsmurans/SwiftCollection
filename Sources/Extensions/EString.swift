//
//  EString.swift
//
//  Created by Gints Murans on 03.11.14.
//  Copyright © 2014 Gints Murans. All rights reserved.
//

import Foundation

// -- Random stuff
public extension String {
    var length: Int {
        get {
            return self.count
        }
    }

    func containsOnly(Chars chars: CharacterSet) -> Bool {
        let invalidTimeCharacterSet = chars.inverted
        let rangeOfInvalidCharacters = self.rangeOfCharacter(from: invalidTimeCharacterSet)
        return (rangeOfInvalidCharacters == nil)
    }

    func substr(_ start: Int = 0, length: Int = 0) -> String? {

        let stringLength = self.length
        var from = 0
        var to = 0

        // Calculate from
        if start < 0 {
            from = stringLength - abs(start)
        }
        else if start > 0 {
            from = start
        }

        // Test from, return nil if false
        if from < 0 {
            return nil
        }

        // Calculate to
        if length == 0 {
            to = stringLength
        }
        else if length > 0 {
            to = from + length
        }
        else if length < 0 {
            to = stringLength - abs(length)
        }

        // Test to, return nil if false
        if to < 0 || to < from || to > stringLength {
            return nil
        }

        // Get the new string
        let range = self.index(self.startIndex, offsetBy: from)..<self.index(self.startIndex, offsetBy: to)
        let new_string = String(self[range])

        return new_string
    }

    func isValidEmail(_ strict: Bool = true) -> Bool {
        // Minimum required characters: a@a.a
        if self.length < 5 {
            return false
        }

        let stricterFilterString = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let laxString = ".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*"
        let emailRegex = strict ? stricterFilterString : laxString
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        return emailTest.evaluate(with: self)
    }
}


// -- Range/NSRange stuff
public extension String {
    init(NSRange range: NSRange) {
        self = NSStringFromRange(range)
    }

    func NSRange() -> NSRange {
        return NSRangeFromString(self)
    }

    func range(_ start: Int, length: Int) -> Range<String.Index> {
        return self.index(self.startIndex, offsetBy: start) ..< self.index(self.startIndex, offsetBy: start + length)
    }

    func range(_ start: Int, end: Int) -> Range<String.Index> {
        return self.index(self.startIndex, offsetBy: start) ..< self.index(self.startIndex, offsetBy: end)
    }

    func range(_ nsRange : NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex) else {
            return nil
        }
        guard let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex) else {
            return nil
        }
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) {
            return from ..< to
        }
        return nil
    }

    func NSRangeFromRange(_ range : Range<String.Index>) -> NSRange {
        let utf16view = self.utf16
        guard let from = String.UTF16View.Index(range.lowerBound, within: utf16view), let to = String.UTF16View.Index(range.upperBound, within: utf16view) else {
            return NSMakeRange(0, 0)
        }

        return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
    }
}
