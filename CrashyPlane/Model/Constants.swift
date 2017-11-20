//
//  Constants.swift
//  CrashyPlane
//
//  Created by Shawn Roller on 11/17/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import UIKit

struct Constants {
    
    // File names
    static let playerImageName = "plane"
    static let skyBackgroundImageName = "sky"
    static let groundBackgroundImageName = "ground"
    static let enemyOneImageName = "enemy-plane"
    static let enemyTwoImageName = "enemy-mine"
    static let allEnemies = [Constants.enemyOneImageName, Constants.enemyTwoImageName]
    
    // Sizes
    static let playerPercentSizeOfScreen: CGFloat = 0.08
    static let enemyPercentSizeOfScreen: CGFloat = 0.08
    
    // Physics
    static let maxPlayerVelocity: CGFloat = 1000
    static let playerImpulse: CGFloat = 12
    
    // Event durations
    static let skyBackgroundScrollDuration: TimeInterval = 10
    static let groundBackgroundScrollDuration: TimeInterval = 6
    static let obstacleMovement: TimeInterval = 6
    static let obstacleCreation: TimeInterval = 1.5
    
}
