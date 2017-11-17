//
//  GameScene.swift
//  CrashyPlane
//
//  Created by Shawn Roller on 11/16/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var sceneManager: GameSceneManager?
    var interactionManager: GameInteractionManager?
    
    // Nodes
    let player = SKSpriteNode(imageNamed: Constants.playerImageName)
    
    override func didMove(to view: SKView) {
        
        // Setup the scene manager
        self.sceneManager = GameSceneManager(scene: self, player: self.player)
        
        // Setup the interaction manager
        self.interactionManager = GameInteractionManager(player: self.player)
        
    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
        // Destroy the managers
        self.sceneManager = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {        
        self.interactionManager?.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.interactionManager?.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.interactionManager?.update(currentTime)
    }
}
