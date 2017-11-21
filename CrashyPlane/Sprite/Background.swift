//
//  Background.swift
//  CrashyPlane
//
//  Created by Shawn Roller on 11/20/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import UIKit
import SpriteKit

struct Background {
    
    private init() {}
    
    static public func getBackgroundNodes(screenWidth: CGFloat, image: String, y: CGFloat, z: CGFloat, needsPhysics: Bool) -> [SKSpriteNode] {
        // Create background nodes that will scroll forever
        var nodes = [SKSpriteNode]()
        for i in 0...1 {
            let node = SKSpriteNode(imageNamed: image)
            
            // Position the first node on the left and the second on the right
            // If the node is for the ground, ensure the node is fully visible on the bottom of the screen
            let yPosition = y == 0 ? 0 : y + (node.size.height / 2)
            node.position = CGPoint(x: (node.size.width - 1) * CGFloat(i), y: yPosition)
            node.zPosition = z
            nodes.append(node)
        }
        return nodes
    }
    
    static public func scrollBackgroundNode(node: SKSpriteNode, screenWidth: CGFloat, duration: Double) {
        // Make the background node scroll
        let move = SKAction.moveBy(x: -node.size.width, y: 0, duration: duration)
        // Move the background back to the right of the screen when it's scrolled all the way
        let wrap = SKAction.moveBy(x: node.size.width, y: 0, duration: 0)
        // Loop them forever
        let sequence = SKAction.sequence([move, wrap])
        let forever = SKAction.repeatForever(sequence)
        // Run the actions
        node.run(forever)
    }
    
}
