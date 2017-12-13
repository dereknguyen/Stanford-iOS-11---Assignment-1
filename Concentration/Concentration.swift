//
//  Concentration.swift
//  Concentration
//
//  Created by Derek Nguyen on 12/9/17.
//  Copyright © 2017 DerekNguyenLearning. All rights reserved.
//

import Foundation
import UIKit

// Classes get a free init as long as all of there instance variable are initialized
class Concentration {
    
    private(set) var totalPoints = 0
    private(set) var flipCounts = 0
    private var numberOfPairsOfCards = 0
    
    private func increaseFlipCount() {
        flipCounts += 1
    }
    
    // You can look at the cards but I'm responsible for setting the card faceup
    //     or facedown -> Thus, private(set)
    private(set) var cards = [Card]()
    
    private var emoji = [Card: String]()
    
    typealias ConcentrationTheme = (emoji: String, backgroundColor: UIColor, cardColor: UIColor, strokeColor: UIColor)
    
    var theme: ConcentrationTheme!
    
    private let emojiChoicesDict: [String: ConcentrationTheme] =  [
        "Halloween" : ("👻🎃😈🍭🍫🍎🦇😱🙀😽💀😭", #colorLiteral(red: 0.6548089385, green: 0.5571696758, blue: 0.7205470204, alpha: 1), #colorLiteral(red: 0.9994197488, green: 0.3977357745, blue: 0.07972980291, alpha: 1), #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)),
        "Food" : ("🥐🥖🌭🥓🍟🍔🌮🥙🥪🥗🌯🍕🍖🥞🍤", #colorLiteral(red: 0.9991268516, green: 0.8008201718, blue: 0, alpha: 1), #colorLiteral(red: 0.8622797132, green: 0.05475250632, blue: 0.1276907325, alpha: 1), #colorLiteral(red: 0.8634563684, green: 0.05905973166, blue: 0.1282699406, alpha: 1)),
        "Activity" : ("🏑⛳️🏹🏒🏈🏀⚾️🏐🎾🏉🎱🛷🥌⛸", #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 0.4402748346, green: 0.1857209802, blue: 0.5457277894, alpha: 1), #colorLiteral(red: 0.4402748346, green: 0.1857209802, blue: 0.5457277894, alpha: 1)),
        "Objects" : ("⌚️💻📱🖥💽💾📷📺🎥☎️⏱🕹🔋", #colorLiteral(red: 0.009783772752, green: 0.6168645024, blue: 0.8627002835, alpha: 1), #colorLiteral(red: 0.8796746135, green: 0.2264508605, blue: 0.2412590086, alpha: 1), #colorLiteral(red: 0.8806566596, green: 0.2246493697, blue: 0.2426902652, alpha: 1))
    ]
    
    private var randomEmojiTheme: String {
        let randomThemeIndex = emojiChoicesDict.count.arc4random
        let emojiThemeList = Array(emojiChoicesDict.keys)
        return emojiThemeList[randomThemeIndex]
    }
    
    // Get the index of the only one face up card on the field
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFacedUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFacedUp = (index == newValue)
            }
        }
    }
    
    func chooseCard(at index: Int) {
        
        if !cards[index].isMatched, !cards[index].isFacedUp {
            
            increaseFlipCount()
            
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                
                // Check if card match
                if cards[matchIndex] == cards[index] {
                    totalPoints += 2
                    
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                else {
                    
                    if cards[index].seen {
                        totalPoints -= 1
                    } else {
                        cards[index].seen = true
                    }
                    
                    if cards[matchIndex].seen {
                        totalPoints -= 1
                    } else {
                        cards[matchIndex].seen = true
                    }
                }
                
                cards[index].isFacedUp = true
                
            } else {
                // either no cards or 2 cards are faced up
                indexOfOneAndOnlyFaceUpCard = index
            }
          
            
        }
    }
    
    func emoji(for card: Card) -> String {
        
        if emoji[card] == nil, theme.emoji.count > 0 {
            
            let randomStringIndex = theme.emoji.index(theme.emoji.startIndex, offsetBy: theme.emoji.count.arc4random)
            emoji[card] = String(theme.emoji.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
    
    func newGame() {
        flipCounts = 0
        totalPoints = 0
        newDeck()
    }
    
    private func newDeck() {
        cards = []
        emoji = [:]
        theme = emojiChoicesDict[randomEmojiTheme]
        
        for _ in 0..<self.numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        
        shuffle()
    }
    
    private func shuffle() {
        var newDeck = [Card]()
        while cards.count > 0 {
            let randomIndex = cards.index(cards.startIndex, offsetBy: cards.count.arc4random)
            newDeck += [cards.remove(at: randomIndex)]
        }
        cards = newDeck
    }
    
    init(numberOfPairsOfCards: Int) {
        self.numberOfPairsOfCards = numberOfPairsOfCards
        newDeck()
    }
    
    
}

extension Collection {
    var oneAndOnly: Element? {
        // Recall:
        //   . count: is a collection method that return count
        //   . first: is a collection method that return first item in the collection
        return count == 1 ? first : nil
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0{
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
        
    }
}
