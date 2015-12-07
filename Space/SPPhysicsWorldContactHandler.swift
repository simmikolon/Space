//
//  SPPhysicsWorldContactHandler.swift
//  Space
//
//  Created by Simon Kemper on 30.11.15.
//  Copyright © 2015 Simon Kemper. All rights reserved.
//

import UIKit
import SpriteKit

struct SPCollisionCategoryBitMask {
    
    static let Player: UInt32 = 0x01
    static let Enemy: UInt32 = 0x02
    static let Platform: UInt32 = 0x03
    static let Bullet: UInt32 = 0x04
    static let EnemyBullet: UInt32 = 0x04
}

protocol SPContactDelegate {
    func didBeginContact(withNode node: SKNode)
}

class SPPhysicsWorldContactHandler: NSObject, SKPhysicsContactDelegate {
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if let nodeA_ = contact.bodyA.node as? SPContactDelegate {
            
            if let nodeB_ = contact.bodyB.node as? SPContactDelegate {
                
                nodeA_.didBeginContact(withNode: nodeB_ as! SKNode)
                nodeB_.didBeginContact(withNode: nodeA_ as! SKNode)
            }
        }
    }
}
