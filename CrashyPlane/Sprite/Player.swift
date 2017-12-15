//
//  Player.swift
//  CrashyPlane
//
//  Created by Shawn Roller on 11/20/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import UIKit
import SpriteKit

class Player: SKSpriteNode {

    init(for width: CGFloat) {
        let texture = SKTexture(imageNamed: Constants.playerImageName)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        // Size the player appropriately for the screen
        NodeCustomizer.resizeNode(self, for: width)
        
        let size = CGSize(width: self.size.width, height: self.size.height)
        self.physicsBody = SKPhysicsBody(texture: texture, size: size)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Obstacle
        self.zPosition = Positions.playerZPosition
        
        if let wind = SKEmitterNode(fileNamed: Constants.windName) {
            wind.position = CGPoint.zero
            self.addChild(wind)
        }
        
        // Collisions with ground and obstacles should be notified
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Obstacle | PhysicsCategory.PassedObstacle | PhysicsCategory.Coin
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func acceleratePlayer() {
        self.physicsBody?.velocity = CGVector(dx: 0, dy: 300)
    }
    
    public func applyImpulseToAcceleratePlayer() {
        // Prevent extremely high Y acceleration
        guard let velocity = self.physicsBody?.velocity, velocity.dy < Constants.maxPlayerVelocity else { return }
        let impulse = SKAction.applyImpulse(CGVector(dx: 0, dy: Constants.playerImpulse * Constants.playerPercentSizeOfScreen), duration: 0.1)
        self.run(impulse)
    }
    
}
