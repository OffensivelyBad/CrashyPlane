//
//  AudioManager.swift
//  CrashyPlane
//
//  Created by Shawn Roller on 12/5/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import Foundation
import SpriteKit

protocol AudioManager {
    func playSoundFileNamed(_ name: String)
}

extension AudioManager where Self: SKScene {
    func playSoundFileNamed(_ name: String) {
        self.run(SKAction.playSoundFileNamed(name, waitForCompletion: false))
    }
}
