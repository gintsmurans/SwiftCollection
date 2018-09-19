//
//  EString.swift
//
//  Created by Gints Murans on 03.11.14.
//  Copyright © 2014 Gints Murans. All rights reserved.
//

import Foundation

// -- Random stuff
public extension String {
    func containsOnly(Chars chars: CharacterSet) -> Bool {
        let invalidTimeCharacterSet = chars.inverted
        let rangeOfInvalidCharacters = self.rangeOfCharacter(from: invalidTimeCharacterSet)
        return (rangeOfInvalidCharacters == nil)
    }

    func isValidEmail(_ strict: Bool = true) -> Bool {
        // Minimum required characters: a@a.a
        if self.count < 5 {
            return false
        }

        let stricterFilterString = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let laxString = ".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*"
        let emailRegex = strict ? stricterFilterString : laxString
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        return emailTest.evaluate(with: self)
    }
}
