//
//  ViewController.swift
//  Concentration
//
//  Created by Derek Nguyen on 11/22/17.
//  Copyright © 2017 DerekNguyenLearning. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Cannot use instance member 'cardButtons' within property initializer; property
    //     initializers run before 'self' is available
    //
    // Meaning: In swift, you have to completely initialize everything before you
    //      can use anything in it.
    //      Obviously we can't use cardButton yet because we haven't finish initializing
    //      everything. We are in the process of initializing "game".
    //
    // Use "Lazy" keyword: the property won't be initialize until being use
    //          No one can use "game" until it is fully initialized
    //
    // Lazy can not have property observer.
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    
    
    // Read only property that has only a "get"
    //  Not settable so you can make this public
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    private var attributes: [NSAttributedStringKey: Any] = [
        .strokeWidth : 5.0,
    ]
    
    private func updateFlipCountLabel() {
        let attributedString = NSAttributedString(string: "Flip: \(game.flipCounts)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    private func updateScoreLabel() {
        let attributtedString = NSAttributedString(string: "Score: \(game.totalPoints)", attributes: attributes)
        scoreLabel.attributedText = attributtedString
    }
    
    // OUTLETS AND ACTIONS ARE ALWAYS PRIVATE
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet private weak var scoreLabel: UILabel! {
        didSet {
            updateScoreLabel()
        }
    }
    
    @IBOutlet private weak var newGameButton: UIButton!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            update()
            
        }
    }
    
    @IBAction func touchNewGame(_ sender: UIButton) {
        game.newGame()
        update()
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if card.isFacedUp {
                button.setTitle(game.emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 0.7019423842, green: 0.5996684432, blue: 0.3662451506, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : game.theme.cardColor
            }
        }
    }
    
    private func update() {
        self.view.backgroundColor = game.theme.backgroundColor
        self.newGameButton.backgroundColor = game.theme.cardColor
        self.attributes[.strokeColor] = game.theme.strokeColor
        updateViewFromModel()
        updateFlipCountLabel()
        updateScoreLabel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }
}








