//
//  SPPlayerSpriteNode.swift
//  Space
//
//  Created by Simon Kemper on 27.11.15.
//  Copyright © 2015 Simon Kemper. All rights reserved.
//

import SpriteKit

struct SPPlayerSettings {
    
    static let PlayerMarginBottom: CGFloat = 150.0
}

protocol SPPlayerSpriteNodeDelegate: class {
    
    func playerSpriteNodeDidFinishUpdate(playerSpriteNode: SPPlayerSpriteNode)
}

protocol SPGeneratorDelegate: class {
    func generatorDidChangeLevel(level level: Double)
}

class SPGenerator: SPSceneDelegate, SPWeaponDelegate {
    
    var level = 50.0
    var capacity = 100.0
    
    var rechargeRate = 10.0
    var rechargeTime = 0.25
    
    weak var delegate: SPGeneratorDelegate?
    
    private var lastTime: NSTimeInterval = 0.0
    
    func update(currentTime: NSTimeInterval) {
     
        let timeDelta = currentTime - lastTime
        
        if timeDelta > rechargeTime {
            
            level += rechargeRate
            if level > capacity { level = capacity }
            else if level < 0 { level = 0 }
            
            lastTime = currentTime
        }
    }
    
    func requestEnergy(value: Double) -> Double {
        
        var returnValue: Double = 0
        
        if level >= value {
            
            level -= value
            returnValue = value
        }
        
        else {
         
            returnValue = level
            level = 0
        }
        
        delegate?.generatorDidChangeLevel(level: level)
        
        return returnValue
    }
    
    func didFinishUpdate() {
        
    }
    
    func weaponDidFire(bullet bullet: SPBullet) {
        
        level -= bullet.energy
        delegate?.generatorDidChangeLevel(level: level)
    }
}

class SPShield: SPSceneDelegate {
    
    var level = 40.0
    var capacity = 100.0
    
    let rechargeRate = 5.0
    let rechargeTime = 0.25
    
    weak var generator: SPGenerator?
    
    private var lastTime: NSTimeInterval = 0.0
    
    func decreaseLevel(value: Double) {
        
        level -= value
        if level < 0 { level = 0 }
    }
    
    func update(currentTime: NSTimeInterval) {
        
        let timeDelta = currentTime - lastTime
        
        if timeDelta > rechargeTime {
            
            if level >= capacity { return }
            
            let availableRechargeRate = generator?.requestEnergy(rechargeRate)
            level += availableRechargeRate!
            
            if level > capacity { level = capacity }
            else if level < 0 { level = 0 }
            
            lastTime = currentTime
        }
    }
    
    func didFinishUpdate() {
        
    }
}

class SPStandardGenerator: SPGenerator {

}

class SPStandardShield: SPShield {
    
}

class SPPlayerSpriteNode: SPSpriteNode, SPSceneDelegate, SPInputHandlerDelegate, SPWeaponDelegate, SPGeneratorDelegate {

    weak var delegate: SPPlayerSpriteNodeDelegate?
    var startPosition = CGPoint(x: 0, y: 0)
    var isShooting = false
    
    var primaryWeapon: SPWeapon?
    var secondaryWeapon: SPWeapon?
    
    var generator: SPGenerator = SPStandardGenerator()
    var shield: SPShield = SPStandardShield()
    
    override func setup() {
        
        startPosition = self.position
        
        func setupPhysics() {
            
            let physicsBody = SKPhysicsBody(rectangleOfSize: size)
            
            physicsBody.affectedByGravity = false;
            physicsBody.dynamic = true;
            physicsBody.categoryBitMask = SPCollisionCategoryBitMask.Player
            physicsBody.contactTestBitMask = SPCollisionCategoryBitMask.EnemyBullet
            physicsBody.collisionBitMask = 0
            physicsBody.usesPreciseCollisionDetection = true;
            physicsBody.allowsRotation = false
            
            self.physicsBody = physicsBody;
        }
        
        func setupWeapons() {
            
            let primaryWeapon_ = SPDoubleMachineGunWeapon(delegate: self, generator: generator, node: self)
            let secondaryWeapon_ = SPDoubleMachineGunWeapon(delegate: self, generator: generator, node: self)
            
            primaryWeapon = primaryWeapon_
            secondaryWeapon = secondaryWeapon_
        }
        
        func setupGenerator() {
            
            generator.delegate = self
        }
        
        func setupShield() {
            
            shield.generator = generator
        }
        
        setupPhysics()
        setupWeapons()
        setupGenerator()
        setupShield()
    }
    
    func didFinishUpdate() {
        
        let deltaX = position.x - startPosition.x
        
        if deltaX > SPScreen.WidthHalf() {
            
            position.x = startPosition.x + SPScreen.WidthHalf()
        }
        
        else if deltaX < -SPScreen.WidthHalf() {
            
            position.x = startPosition.x - SPScreen.WidthHalf()
        }
        
        delegate?.playerSpriteNodeDidFinishUpdate(self)
    }
    
    func update(currentTime: NSTimeInterval) {
        
        generator.update(currentTime)
        shield.update(currentTime)
    }
    
    func inputHandlerDidChangeMotion(xAcceleration: CGFloat) {
        
        physicsBody?.velocity = CGVector(dx: xAcceleration, dy: physicsBody!.velocity.dy)
    }
    
    func inputHandlerDidBeginTouches() {
        
        if let weapon = primaryWeapon {
            
            weapon.startFire()
        }
    }
    
    func inputHandlerDidEndTouched() {

        if let weapon = primaryWeapon {
            
            weapon.stopFire()
        }
    }
    
    override func didBeginContact(withNode node: SKNode) {
     
        if node is SPEnemyBullet {
            
            if let bullet = node as? SPEnemyBullet {
                
                shield.decreaseLevel(bullet.damage)
                bullet.removeFromParent()
            }
        }
    }
    
    func weaponDidFire(bullet bullet: SPBullet) {
        
        generator.weaponDidFire(bullet: bullet)
    }
    
    func generatorDidChangeLevel(level level: Double) {
        
    }
}
