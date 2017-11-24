//
//  Coin.swift
//  CrashyPlane
//
//  Created by Shawn Roller on 11/24/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

struct Coin {
    
    private init() {}
    
    static func createCoin(screenWidth: CGFloat, screenHeight: CGFloat) -> SKSpriteNode {
        
        let coin = SKSpriteNode(imageNamed: Constants.coinName)
        
        // Position it on top of the background and off the right of the screen
        coin.zPosition = Positions.coinZPosition
        coin.position.x = screenWidth
        
        // Size the coin appropriately for the screen
        NodeCustomizer.resizeNode(coin, for: screenWidth)
        
        // Put it in a random Y position
        let randomY = GKRandomDistribution(lowestValue: Int(-(screenHeight / 4)), highestValue: Int(screenHeight / 2))
        coin.position.y = CGFloat(randomY.nextInt())
        
        // Add physics
        let size = CGSize(width: coin.size.width, height: coin.size.height)
        coin.physicsBody = SKPhysicsBody(texture: coin.texture!, size: size)
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.categoryBitMask = PhysicsCategory.Coin
        coin.physicsBody?.collisionBitMask = PhysicsCategory.Obstacle
        
        return coin
    }
    
    static public func moveCoin(node: SKSpriteNode) {
        
        // Move the obstacle across the screen
        let duration = Constants.coinMovement
        let xPosition = -node.position.x
        let xMovement = SKAction.moveTo(x: xPosition, duration: duration)
        node.run(xMovement)
        
    }
    
}
