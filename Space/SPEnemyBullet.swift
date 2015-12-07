//
//  SPEnemyBullet.swift
//  Space
//
//  Created by Simon Kemper on 03.12.15.
//  Copyright © 2015 Simon Kemper. All rights reserved.
//

import UIKit
import SpriteKit

class SPEnemyBullet: SPSpriteNode, SPSceneDelegate {
    
    var damage: Double = 15
    
    func update(currentTime: NSTimeInterval) {
        
    }
    
    func didFinishUpdate() {
        
        if position.y < 0 {
            
            removeAllActions()
            removeAllChildren()
            removeFromParent()
        }
    }
}