//
//  SPBullet.swift
//  Space
//
//  Created by Simon Kemper on 30.11.15.
//  Copyright © 2015 Simon Kemper. All rights reserved.
//

import UIKit
import SpriteKit

class SPBullet: SPSpriteNode, SPSceneDelegate {
 
    var damage: Int = 5
    var energy = 5.0
    
    func update(currentTime: NSTimeInterval) {
        
    }
    
    func didFinishUpdate() {
        
        if position.y > SPScreen.Height {
            
            removeAllActions()
            removeAllChildren()
            removeFromParent()
        }
    }
}
