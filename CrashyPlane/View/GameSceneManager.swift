//
//  GameSceneManager.swift
//  CrashyPlane
//
//  Created by Shawn Roller on 11/17/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import Foundation
import SpriteKit

class GameSceneManager {
    
    // Initialize the manager and setup the scene
    let scene: SKScene
    let player: SKSpriteNode
    init(scene: SKScene, player: SKSpriteNode) {
        self.scene = scene
        self.player = player
        setupScene()
    }
    
    // Convenience properties
    private var screenWidth: CGFloat {
        return self.scene.size.width
    }
    private var screenHeight: CGFloat {
        return self.scene.size.height
    }
    private var leftPadding: CGFloat {
        return -(self.screenWidth / 2) + (self.player.size.width * 1)
    }
    private var topPadding: CGFloat {
        return (self.screenHeight / 2) - (self.player.size.height * 1)
    }
    
}

// MARK: - Scene setup
extension GameSceneManager {
    
    private func setupScene() {
        setupPhysicsWorld()
        setupPlayer()
    }
    
    private func setupPlayer() {
        let aspectRatio = self.player.size.width / self.player.size.height
        let playerWidth = self.screenWidth * Constants.playerPercentSizeOfScreen
        self.player.size = CGSize(width: playerWidth, height: playerWidth / aspectRatio)
        self.player.position = CGPoint(x: self.leftPadding, y: self.topPadding)
        self.player.physicsBody = SKPhysicsBody(texture: self.player.texture!, size: self.player.texture!.size())
        self.scene.addChild(self.player)
    }
    
    private func setupPhysicsWorld() {
        self.scene.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
    }
    
}
