//
//  String+Extension.swift
//  Framily
//
//  Created by Varun kumar on 20/07/23.
//

import Foundation

extension String {
    /**
     true if self contains characters.
     */
    public var isNotEmpty: Bool {
        return !isEmpty
    }
    
    
    func satisfiesRegexp(_ regexp: String) -> Bool {
        return range(of: regexp, options: .regularExpression) != nil
    }
}

