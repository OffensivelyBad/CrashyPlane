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
    
    static public func getRandomObstacle(screenWidth: CGFloat, screenHeight: CGFloat) -> SKSpriteNode {
        
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
        resizeObstacle(obstacle, for: screenWidth)
        
        // Put it in a random Y position
        let randomY = GKRandomDistribution(lowestValue: Int(-(screenHeight / 4)), highestValue: Int(screenHeight / 2))
        obstacle.position.y = CGFloat(randomY.nextInt())
        
        // Add physics
        let size = CGSize(width: obstacle.size.width, height: obstacle.size.height)
        obstacle.physicsBody = SKPhysicsBody(texture: obstacle.texture!, size: size)
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        
        return obstacle
    }
    
    static public func moveObstacle(node: SKSpriteNode) {
        
        var duration = Constants.obstacleMovement
        
        if node.name == Constants.enemyOneImageName {
            // Make the first enemy move faster
            duration = duration / 1.5
        }
        
        let xPosition = -node.position.x
        let xMovement = SKAction.moveTo(x: xPosition, duration: duration)
        node.run(xMovement)
        
    }
    
    private static func resizeObstacle(_ obstacle: SKSpriteNode, for width: CGFloat) {
        let aspectRatio = obstacle.size.width / obstacle.size.height
        let obstacleWidth = width * Constants.playerPercentSizeOfScreen
        obstacle.size = CGSize(width: obstacleWidth, height: obstacleWidth / aspectRatio)
    }
    
}
