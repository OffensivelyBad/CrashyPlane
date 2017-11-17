//
//  GameInteractionManager.swift
//  CrashyPlane
//
//  Created by Shawn Roller on 11/17/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import Foundation
import SpriteKit

class GameInteractionManager {
    
    let player: SKSpriteNode
    init(player: SKSpriteNode) {
        self.player = player
    }
    
    // Game properties
    private var touchingScreen = false
    private var applyTouchImpulse = true // When true, this applies an impulse to the player which increases the difficulty but makes the flight more realistic 
    
}

// MARK: - Handle taps
extension GameInteractionManager {
    
    public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchingScreen = true
    }
    
    public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchingScreen = false
    }
    
    public func update(_ currentTime: TimeInterval) {
        guard self.touchingScreen else { return }
        
        if self.applyTouchImpulse {
            let impulse = SKAction.applyImpulse(CGVector(dx: 0, dy: 10), duration: 0.1)
            self.player.run(impulse)
        }
        else {
            self.player.physicsBody?.velocity = CGVector(dx: 0, dy: 300)
        }
    }
}
