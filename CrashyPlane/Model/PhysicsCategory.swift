//
//  PhysicsCategory.swift
//  CrashyPlane
//
//  Created by Shawn Roller on 11/17/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import Foundation

struct PhysicsCategory {
    
    private init() {}
    
    static let Player: UInt32 = 0x1 << 0
    static let Obstacle: UInt32 = 0x1 << 1
    static let Ground: UInt32 = 0x1 << 2
    
}
