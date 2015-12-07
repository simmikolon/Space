//
//  SPDoubleMachineGunWeapon.swift
//  Space
//
//  Created by Simon Kemper on 01.12.15.
//  Copyright © 2015 Simon Kemper. All rights reserved.
//

import UIKit
import SpriteKit

protocol SPWeapon {
    
    var repetitionRate: NSTimeInterval { get }
    var energyPerShot: Int { get }
    var firing: Bool {get set}
    func setup()
    func startFire()
    func stopFire()
}

protocol SPWeaponDelegate: class {
    
    func weaponDidFire(bullet bullet: SPBullet)
}

class SPDoubleMachineGunWeapon: SPWeapon {

    let repetitionRate: NSTimeInterval = 0.15
    let energyPerShot: Int = 1
    
    var firing: Bool = false
    var shootIndex: CGFloat = 0.0
    
    unowned var node: SKNode
    unowned var delegate: SPWeaponDelegate
    unowned var generator: SPGenerator
    
    init(delegate: SPWeaponDelegate, generator: SPGenerator, node: SKNode) {
        
        self.delegate = delegate
        self.generator = generator
        self.node = node
    }
    
    func setup() {
        
    }
    
    func startFire() {
        
        if !firing {
            
            let waitAction = SKAction.waitForDuration(repetitionRate)
            
            let shootAction = SKAction.runBlock({ () -> Void in
                
                let energyNeeded = 5.0
                
                if self.generator.level < energyNeeded {
                    
                    return
                }
                
                var bullet = SPBullet(color: UIColor.magentaColor(), size: CGSize(width: 5, height: 15))
                
                bullet.position = self.node.position
                bullet.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 5, height: 5))
                bullet.physicsBody?.affectedByGravity = false
                bullet.physicsBody?.dynamic = true
                bullet.physicsBody?.collisionBitMask = 0
                bullet.physicsBody?.contactTestBitMask = SPCollisionCategoryBitMask.Enemy
                bullet.physicsBody?.categoryBitMask = SPCollisionCategoryBitMask.Bullet
                bullet.physicsBody?.velocity.dy = 1000.0
                bullet.physicsBody?.velocity.dx = 75.0
                
                self.delegate.weaponDidFire(bullet: bullet)
                self.node.addChild(bullet)
                
                
                
                bullet = SPBullet(color: UIColor.magentaColor(), size: CGSize(width: 5, height: 15))
                
                bullet.position = self.node.position
                bullet.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 5, height: 5))
                bullet.physicsBody?.affectedByGravity = false
                bullet.physicsBody?.dynamic = true
                bullet.physicsBody?.collisionBitMask = 0
                bullet.physicsBody?.contactTestBitMask = SPCollisionCategoryBitMask.Enemy
                bullet.physicsBody?.categoryBitMask = SPCollisionCategoryBitMask.Bullet
                bullet.physicsBody?.velocity.dy = 1000.0
                bullet.physicsBody?.velocity.dx = -75.0
                
                self.delegate.weaponDidFire(bullet: bullet)
                self.node.addChild(bullet)
                
                
                
                bullet = SPBullet(color: UIColor.magentaColor(), size: CGSize(width: 5, height: 15))
                
                bullet.position = self.node.position
                bullet.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 5, height: 5))
                bullet.physicsBody?.affectedByGravity = false
                bullet.physicsBody?.dynamic = true
                bullet.physicsBody?.collisionBitMask = 0
                bullet.physicsBody?.contactTestBitMask = SPCollisionCategoryBitMask.Enemy
                bullet.physicsBody?.categoryBitMask = SPCollisionCategoryBitMask.Bullet
                bullet.physicsBody?.velocity.dy = 1000.0
                bullet.physicsBody?.velocity.dx = 0.0
                
                self.delegate.weaponDidFire(bullet: bullet)
                self.node.addChild(bullet)
            })
            
            let shootSequenceAction = SKAction.sequence([shootAction,waitAction])
            let repetitionAction = SKAction.repeatActionForever(shootSequenceAction)
            
            node.runAction(repetitionAction, withKey: "shootingAction")
            
            firing = true
        }
    }
    
    func stopFire() {
        
        if firing {
            
            node.removeActionForKey("shootingAction")
            firing = false
        }
    }
}
