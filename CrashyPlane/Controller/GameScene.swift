//
//  GameScene.swift
//  CrashyPlane
//
//  Created by Shawn Roller on 11/16/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

/*
 
 // TODO
 
 make obstacles collide with each other
 zoom in on explosions
 slow down time when explosions occur
 make a game over scene
 ability to restart the game
 add scoring mechanism
 prevent player from leaving the screen too high
 remove obstacles when they leave the screen
 
 */

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // Game state
    var gameState: GameState!
    
    // Manage collisions via delegate
    var collisionManager: GameSceneCollisionManager!
    
    // Sprite nodes
    private var player: Player!
    
    // Convenience properties
    private var screenWidth: CGFloat {
        return self.size.width
    }
    private var screenHeight: CGFloat {
        return self.size.height
    }
    private var leftPadding: CGFloat {
        return -(self.screenWidth / 2) + (self.player.size.width * 1)
    }
    private var topPadding: CGFloat {
        return (self.screenHeight / 2) - (self.player.size.height * 1)
    }
    
}

// MARK: - Init and deinit
extension GameScene {
    
    override func didMove(to view: SKView) {
        
        // Create and add the player
        createPlayer()
        
        // Create and add the parallax scrolling background
        createBackground()
        
        // Setup the physics world
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        
        // Delegate collisions to the collision manager
        self.physicsWorld.contactDelegate = self.collisionManager
        
        // Begin creating obstacles
        self.gameState.createTimerForObstacle(interval: Constants.obstacleCreation)
    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
    }
    
}

// MARK: - Handle touches
extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.gameState.touchingScreen = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.gameState.touchingScreen = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Accelerate the player
        if self.gameState.touchingScreen {
            self.player.applyImpulseToAcceleratePlayer()
        }
    }
    
}

// MARK: - Node management
extension GameScene {
    
    private func createPlayer() {
        self.player = Player(for: self.screenWidth)
        self.player.position = CGPoint(x: self.leftPadding, y: self.topPadding)
        self.addChild(self.player)
    }
    
    private func createBackground() {
        let skyNodes = Background.getBackgroundNodes(screenWidth: self.screenWidth, image: Constants.skyBackgroundImageName, y: 0, z: Positions.skyBackgroundZPosition, needsPhysics: false)
        let groundNodes = Background.getBackgroundNodes(screenWidth: self.screenWidth, image: Constants.groundBackgroundImageName, y: -(self.screenHeight / 2), z: Positions.groundBackgroundZPosition, needsPhysics: true)
        
        for node in skyNodes {
            self.addChild(node)
            Background.scrollBackgroundNode(node: node, screenWidth: self.screenWidth, duration: Constants.skyBackgroundScrollDuration)
        }
        for node in groundNodes {
            self.addChild(node)
            Background.scrollBackgroundNode(node: node, screenWidth: self.screenWidth, duration: Constants.groundBackgroundScrollDuration)
        }
        
    }
    
}

// MARK: - GameStateDelegate
extension GameScene: GameStateDelegate {
    
    public func createObstacle() {
        
        // Create and add a random obstacle
        let obstacle = Obstacle.getRandomObstacle(screenWidth: self.screenWidth, screenHeight: self.screenHeight)
        self.addChild(obstacle)
        
        // Move the obstacle
        Obstacle.moveObstacle(node: obstacle)
        
    }
    
}

// MARK: - Collision Delegate
extension GameScene: CollisionDelegate {
    
    func addNode(_ node: SKNode) {
        self.addChild(node)
    }
    
}

