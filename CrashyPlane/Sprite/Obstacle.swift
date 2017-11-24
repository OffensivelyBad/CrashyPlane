//
//  Obstacle.swift
//  CrashyPlane
//
//  Created by Shawn Roller on 11/20/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

struct Obstacle {
    
    private init() {}
    
    static public func getRandomObstacleWithCollisionBlock(screenWidth: CGFloat, screenHeight: CGFloat) -> SKSpriteNode {
        
        // Get a random obstacle
        let randomObstacle = GKRandomDistribution(lowestValue: 0, highestValue: Constants.allEnemies.count - 1)
        let obstacleName = Constants.allEnemies[randomObstacle.nextInt()]
        let obstacle = SKSpriteNode(imageNamed: obstacleName)
        
        // Assign a name to the obstacle so they can be moved at different speeds
        obstacle.name = obstacleName
        
        // Position it on top of the background and off the right of the screen
        obstacle.zPosition = Positions.obstacleZPosition
        obstacle.position.x = screenWidth
        
        // Size the obstacle appropriately for the screen
        NodeCustomizer.resizeNode(obstacle, for: screenWidth)
        
        // Put it in a random Y position
        let randomY = GKRandomDistribution(lowestValue: Int(-(screenHeight / 4)), highestValue: Int(screenHeight / 2))
        obstacle.position.y = CGFloat(randomY.nextInt())
        
        // Add physics
        let size = CGSize(width: obstacle.size.width, height: obstacle.size.height)
        obstacle.physicsBody = SKPhysicsBody(texture: obstacle.texture!, size: size)
        obstacle.physicsBody?.affectedByGravity = false
        obstacle.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        
        // Make obstacles collide with one another
        obstacle.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Coin
        obstacle.physicsBody?.collisionBitMask = PhysicsCategory.Obstacle | PhysicsCategory.Coin
        
        // Make a collision block that will be used for scoring
        let collisionSize = CGSize(width: 10, height: screenHeight * 2)
        let collision = SKSpriteNode(color: .clear, size: collisionSize)
        collision.physicsBody = SKPhysicsBody(rectangleOf: collision.size)
        collision.physicsBody?.isDynamic = false
        collision.physicsBody?.categoryBitMask = PhysicsCategory.PassedObstacle
        collision.position.y = 0
        collision.position.x = obstacle.size.width
        
        // Add the collision block to the obstacle
        obstacle.addChild(collision)
        
        return obstacle
    }
    
    static public func moveObstacle(node: SKSpriteNode) {
        
        var duration = Constants.obstacleMovement
        
        // If it's the first enemy make the obstacle move more quicly across the screen
        if node.name == Constants.enemyOneImageName {
            duration = duration / 1.5
        }
        
        // Move the obstacle across the screen
        let xPosition = -node.position.x
        let xMovement = SKAction.moveTo(x: xPosition, duration: duration)
        node.run(xMovement)
        
    }
    
}
