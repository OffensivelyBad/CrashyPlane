//
//  GameState.swift
//  CrashyPlane
//
//  Created by Shawn Roller on 11/20/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import UIKit
import SpriteKit

protocol GameStateDelegate {
    func createObstacle()
}

class GameState {
    var delegate: GameStateDelegate?
    init(delegate: GameStateDelegate?) {
        self.delegate = delegate
    }
    
    // Scoring
    var scoringLabel: SKLabelNode?
    var score: Int = 0 {
        didSet {
            self.scoringLabel?.text = "Score: \(score)"
        }
    }
    
    // Rules
    let applyTouchImpulse = true
    var gameDidBegin = false
    var gameOver = false
    
    // Interactions
    var touchingScreen = false
    
    // Timer
    var timer: Timer?
    
    public func createTimerForObstacle(interval: TimeInterval) {
        
        // Begin the game
        self.gameDidBegin = true
        
        // Set an initial score
        self.score = 0
        
        // Start the timer to create obstacles
        self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { (_) in
            self.delegate?.createObstacle()
        })
        
    }
    
    public func getScoringLabel() -> SKNode {
        
        self.scoringLabel = SKLabelNode(fontNamed: Constants.scoreLabelFont)
        self.scoringLabel?.zPosition = Positions.scoringLabelZPosition
        return self.scoringLabel!
        
    }
    
}

// MARK: - ScoringDelegate
extension GameState: ScoringDelegate {
    
    func addPointsToScore(_ score: Int) {
        self.score += score
    }
    
    func gameEnded() {
        self.gameOver = true
    }
    
}
