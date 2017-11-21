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
        
        // Position it on top of the background and off the right of the screen
        obstacle.zPosition = Positions.obstacleZPosition
        obstacle.position.x = screenWidth
        
        // Put it in a random Y position
        let randomY = GKRandomDistribution(lowestValue: Int(-(screenHeight / 4)), highestValue: Int(screenHeight / 2))
        obstacle.position.y = CGFloat(randomY.nextInt())
        
        return obstacle
    }
    
    static public func moveObstacle(node: SKSpriteNode) {
        
        let xPosition = -node.position.x
        let xMovement = SKAction.moveTo(x: xPosition, duration: Constants.obstacleMovement)
        node.run(xMovement)
        
    }
    
}
