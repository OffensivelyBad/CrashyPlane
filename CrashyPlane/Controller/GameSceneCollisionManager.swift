//
//  GameSceneContactManager.swift
//  CrashyPlane
//
//  Created by Shawn Roller on 11/23/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import Foundation
import SpriteKit

protocol CollisionDelegate {
    func addNode(_ node: SKNode)
}
protocol ScoringDelegate {
    func addPointsToScore(_ score: Int)
    func gameEnded()
}

class GameSceneCollisionManager: NSObject, SKPhysicsContactDelegate {
    
    let collisionDelegate: CollisionDelegate!
    let scoringDelegate: ScoringDelegate!
    let audioDelegate: AudioManager!
    init(collisionDelegate: CollisionDelegate, scoringDelegate: ScoringDelegate, audioDelegate: AudioManager) {
        self.collisionDelegate = collisionDelegate
        self.scoringDelegate = scoringDelegate
        self.audioDelegate = audioDelegate
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node else { return }
        
        var firstNode: SKNode
        var secondNode: SKNode
        
        // Sort the nodes so the player is always first
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstNode = nodeA
            secondNode = nodeB
        }
        else {
            firstNode = nodeB
            secondNode = nodeA
        }
        
        guard let firstBody = firstNode.physicsBody, let secondBody = secondNode.physicsBody else { return }
        
        switch (firstBody.categoryBitMask, secondBody.categoryBitMask) {
        case (PhysicsCategory.Player, PhysicsCategory.Ground):
            playerHitGround(firstNode, groundNode: secondNode)
        case (PhysicsCategory.Player, PhysicsCategory.Obstacle):
            playerHitObstacle(playerNode: firstNode, obstacleNode: secondNode)
        case (PhysicsCategory.Obstacle, PhysicsCategory.Obstacle), (PhysicsCategory.Obstacle, PhysicsCategory.Coin):
            obstacleHitObstacle(firstNode: firstNode, secondNode: secondNode)
        case (PhysicsCategory.Player, PhysicsCategory.PassedObstacle):
            playerPassedObstacle(secondNode)
        case (PhysicsCategory.Player, PhysicsCategory.Coin):
            playerCollectedCoin(secondNode)
        default:
            ()
        }
        
    }
    
    private func playerHitObstacle(playerNode: SKNode, obstacleNode: SKNode) {
        
        guard let playerExplosion = SKEmitterNode(fileNamed: Constants.playerExplosion) else { return }
        guard let enemyExplosion = SKEmitterNode(fileNamed: Constants.enemyExplosion) else { return }
        
        // Play a sound effect
        self.audioDelegate.playSoundFileNamed(Constants.explosionSoundName)
        
        // Remove the player in a blaze of glory
        let explosionWait = SKAction.wait(forDuration: Constants.playerExplosionDuration)
        let playerExplosionAction = SKAction.run {
            playerExplosion.position = playerNode.position
            self.collisionDelegate.addNode(playerExplosion)
            playerNode.removeFromParent()
            playerExplosion.run(SKAction.sequence([explosionWait, SKAction.removeFromParent()]))
        }
        
        // Remove the obstacle
        let obstacleExplosionWait = SKAction.wait(forDuration: Constants.obstacleExplosionDuration)
        let enemyExplosionAction = SKAction.run {
            enemyExplosion.position = obstacleNode.position
            self.collisionDelegate.addNode(enemyExplosion)
            obstacleNode.removeFromParent()
            enemyExplosion.run(SKAction.sequence([obstacleExplosionWait, SKAction.removeFromParent()]))
        }
        
        playerNode.run(playerExplosionAction)
        obstacleNode.run(enemyExplosionAction)
        
        // Set game over
        self.scoringDelegate.gameEnded()
        
    }
    
    private func playerHitGround(_ playerNode: SKNode, groundNode: SKNode) {
        
        guard let playerExplosion = SKEmitterNode(fileNamed: Constants.playerExplosion) else { return }
        
        // Play a sound effect
        self.audioDelegate.playSoundFileNamed(Constants.explosionSoundName)
        
        // Remove the player in a blaze of glory
        let explosionWait = SKAction.wait(forDuration: Constants.playerExplosionDuration)
        let playerExplosionAction = SKAction.run {
            playerExplosion.position = playerNode.position
            self.collisionDelegate.addNode(playerExplosion)
            playerNode.removeFromParent()
            playerExplosion.run(SKAction.sequence([explosionWait, SKAction.removeFromParent()]))
        }
        playerNode.run(playerExplosionAction)
        
        // Set game over
        self.scoringDelegate.gameEnded()
        
    }
    
    private func obstacleHitObstacle(firstNode: SKNode, secondNode: SKNode) {
        
        guard let enemyExplosion = SKEmitterNode(fileNamed: Constants.enemyExplosion) else { return }
        
        // Play a sound effect
        self.audioDelegate.playSoundFileNamed(Constants.explosionSoundName)
        let enemyExplosionTwo = enemyExplosion.copy() as! SKEmitterNode
        
        // Make the obstacles hit each other and then explode after a brief delay
        let wait = SKAction.wait(forDuration: Constants.obstacleCollisionDelay)
        let explosionWait = SKAction.wait(forDuration: Constants.obstacleExplosionDuration)
        let removeExplosion = SKAction.removeFromParent()
        let firstExplosion = SKAction.run {
            enemyExplosion.position = firstNode.position
            self.collisionDelegate.addNode(enemyExplosion)
            firstNode.removeFromParent()
            enemyExplosion.run(SKAction.sequence([explosionWait, removeExplosion]))
        }
        let secondExplosion = SKAction.run {
            enemyExplosionTwo.position = secondNode.position
            self.collisionDelegate.addNode(enemyExplosionTwo)
            secondNode.removeFromParent()
            enemyExplosionTwo.run(SKAction.sequence([explosionWait, removeExplosion]))
        }
        firstNode.run(SKAction.sequence([wait, firstExplosion]))
        secondNode.run(SKAction.sequence([wait, secondExplosion]))
        
    }
    
    private func playerPassedObstacle(_ scoringNode: SKNode) {
        
        // Play a sound effect
        self.audioDelegate.playSoundFileNamed(Constants.scoreSoundName)
        
        // Remove the scoring node to prevent scores from racking up more than once
        scoringNode.removeFromParent()
        // Add points to the score
        self.scoringDelegate.addPointsToScore(Constants.passedObstacleScore)
    }
    
    private func playerCollectedCoin(_ scoringNode: SKNode) {
        
        // Play a sound effect
        self.audioDelegate.playSoundFileNamed(Constants.scoreSoundName)
        
        // Remove the coin node to prevent scores from racking up more than once
        scoringNode.removeFromParent()
        // Add points to the score
        self.scoringDelegate.addPointsToScore(Constants.collectedCoinScore)
    }
    
}



