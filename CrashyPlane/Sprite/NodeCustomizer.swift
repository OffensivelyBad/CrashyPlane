//
//  NodeCustomizer.swift
//  CrashyPlane
//
//  Created by Shawn Roller on 11/24/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import Foundation
import SpriteKit

struct NodeCustomizer {
    
    static func resizeNode(_ node: SKSpriteNode, for width: CGFloat) {
        let aspectRatio = node.size.width / node.size.height
        let nodeWidth = width * Constants.playerPercentSizeOfScreen
        node.size = CGSize(width: nodeWidth, height: nodeWidth / aspectRatio)
    }
    
}
