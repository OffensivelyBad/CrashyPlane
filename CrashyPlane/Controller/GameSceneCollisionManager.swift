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

class GameSceneCollisionManager: NSObject, SKPhysicsContactDelegate {
    
    var delegate: CollisionDelegate!
    init(delegate: CollisionDelegate) {
        self.delegate = delegate
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
        case (PhysicsCategory.Player, PhysicsCategory.Ground), (PhysicsCategory.Player, PhysicsCategory.Obstacle):
            playerNode(firstNode, hitBy: secondNode)
        default:
            ()
        }
        
    }
    
    private func playerNode(_ node: SKNode, hitBy secondNode: SKNode) {
        
        guard let secondPhysicsBody = secondNode.physicsBody else { return }
        guard let playerExplosion = SKEmitterNode(fileNamed: Constants.playerExplosion) else { return }
        
        // Remove the player in a blaze of glory
        playerExplosion.position = node.position
        self.delegate.addNode(playerExplosion)
        node.removeFromParent()
        
        // Remove the obstacle if that's what was hit
        if secondPhysicsBody.categoryBitMask == PhysicsCategory.Obstacle {
            guard let enemyExplosion = SKEmitterNode(fileNamed: Constants.enemyExplosion) else { return }
            enemyExplosion.position = secondNode.position
            self.delegate.addNode(enemyExplosion)
            secondNode.removeFromParent()
        }
        
    }
    
}
