//
//  Card.swift
//  Concentration
//
//  Created by Derek Nguyen on 12/9/17.
//  Copyright © 2017 DerekNguyenLearning. All rights reserved.
//

import Foundation

struct Card: Hashable {
    
    var hashValue: Int { return identifier }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFacedUp = false
    var isMatched = false
    var seen = false
    private var identifier: Int
    
    private static var identifierFactory = 0
    
    // Function that tie to the type and not the object itself
    // Like a global variable
    private static func getUniqueIdentifier() -> Int {
        self.identifierFactory += 1
        return self.identifierFactory
    }
    
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
