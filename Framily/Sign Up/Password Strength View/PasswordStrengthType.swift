//
//  PasswordStrengthType.swift
//  Framily
//
//  Created by Varun kumar on 20/07/23.
//

import Foundation


enum StrengthType {
    case weak
    case medium
    case strong
    case veryStrong
}

public enum ValidationRequiredRule {
    case lowerCase
    case uppercase
    case digit
    case specialCharacter
    case oneUniqueCharacter
    case minmumLength
}

