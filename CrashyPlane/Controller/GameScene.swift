//
//  GameScene.swift
//  CrashyPlane
//
//  Created by Shawn Roller on 11/16/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

/*
 
 // TODO
 
 Apply an impulse when enemies collide with coins/other enemies
 Maybe don't make the coins explode if hit by enemies
 zoom in on explosions
 slow down time when explosions occur
 make a game over scene
 ability to restart the game
 remove obstacles when they leave the screen
 make player tilt when moving up/down
 make enemies move and target the player in later levels
 make enemies avoid obstacles that can kill them
 make enemies crash into ground
 
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
    
    private var enemiesCreated = 0
    private var coinsCreated = 0
    
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
        
        // Create the scoring label
        createScoringLabel()
        
        // Delegate collisions to the collision manager
        self.physicsWorld.contactDelegate = self.collisionManager
        
        // Set initial gravity to zero until game starts
        self.physicsWorld.gravity = CGVector.zero
        
    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
    }
    
    private func startGame() {
        
        // Setup the physics world
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        
        // Begin creating obstacles
        self.gameState.createTimerForObstacle(interval: Constants.obstacleCreation)
        
    }
    
}

// MARK: - Handle touches
extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !self.gameState.gameDidBegin {
            startGame()
        }
        
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
        // Ensure the player doesn't go too far off screen
        let maxHeight = (self.screenHeight / 2)
        if player.position.y > maxHeight {
            player.position.y = maxHeight
            return
        }
        // Accelerate the player if it's below maximum height
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
    
    private func createScoringLabel() {
        let scoringLabel = self.gameState.getScoringLabel()
        let yPosition = -(self.screenHeight / 2) + 10
        scoringLabel.position = CGPoint(x: 0, y: yPosition)
        self.addChild(scoringLabel)
    }
    
    private func createCoin() {
        
        let coin = Coin.createCoin(screenWidth: self.screenWidth, screenHeight: self.screenHeight)
        self.addChild(coin)
        self.coinsCreated += 1
        Coin.moveCoin(node: coin)
        
    }
    
}

// MARK: - GameStateDelegate
extension GameScene: GameStateDelegate {
    
    public func createObstacle() {
        
        // Create and add a random obstacle
        let obstacle = Obstacle.getRandomObstacleWithCollisionBlock(screenWidth: self.screenWidth, screenHeight: self.screenHeight)
        self.addChild(obstacle)
        self.enemiesCreated += 1
        
        // Move the obstacles
        Obstacle.moveObstacle(node: obstacle)
        
        if self.enemiesCreated % Constants.enemiesPerCoin == 0 {
            // Create a coin
            createCoin()
        }
        
    }
    
}

// MARK: - Collision Delegate
extension GameScene: CollisionDelegate {
    
    func addNode(_ node: SKNode) {
        self.addChild(node)
    }
    
}

