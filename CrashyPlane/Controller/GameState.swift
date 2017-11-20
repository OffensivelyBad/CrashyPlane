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
    
    // Rules
    let applyTouchImpulse = true
    
    // Interactions
    var touchingScreen = false
    
    // Timer
    var timer: Timer?
    
    public func createTimerForObstacle(interval: TimeInterval) {
        
        self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { (_) in
            self.delegate?.createObstacle()
        })
        
    }
    
}
