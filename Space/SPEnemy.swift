//
//  SPEnemy.swift
//  Space
//
//  Created by Simon Kemper on 30.11.15.
//  Copyright © 2015 Simon Kemper. All rights reserved.
//

import UIKit
import SpriteKit

protocol SPEnemyDelegate: class {

    func enemyWillDisapper(enemy: SPEnemy)
}

enum SPEnemyState: Int {
    case Idle
    case Shooting
    case CourseChanging
}

class SPEnemy: SPSpriteNode, SPSceneDelegate {

    weak var delegate: SPEnemyDelegate?
    var energy: Int = 20
    var startTime: NSTimeInterval = 0.0
    var enemyStateDuration = 0.2
    var state: SPEnemyState = SPEnemyState.Idle
    
    convenience init() {
        
        self.init(color: SKColor.redColor(), size: CGSize(width: 35, height: 35))
        
        func setupPhysics() {
            
            let body = SKPhysicsBody(rectangleOfSize: CGSize(width: 35, height: 35))
            
            body.categoryBitMask = SPCollisionCategoryBitMask.Enemy
            body.contactTestBitMask = SPCollisionCategoryBitMask.Bullet
            body.collisionBitMask = 0
            body.dynamic = true
            body.affectedByGravity = false
            body.velocity = CGVector(dx: 0.0, dy: -500.0)
            
            physicsBody = body
        }
        
        setupPhysics()
    }
    
    override func setup() {
        
    }
    
    private func changeCourse() {
        
        let blockAction = SKAction.runBlock { () -> Void in
            if self.position.x > SPScreen.WidthHalf() {
                self.physicsBody?.velocity.dx = -200.0
            } else {
                self.physicsBody?.velocity.dx = 200.0
            }
        }
        
        runAction(blockAction)
    }
    
    private func nextState() {
        
        if let newState = SPEnemyState(rawValue: state.rawValue + 1) {
            
            state = newState
            
        } else {
            
            state = SPEnemyState.Idle
        }
    }
    
    private func shoot() {
        
        let waitAction = SKAction.waitForDuration(0.2)
        let shootAction = SKAction.runBlock({ () -> Void in
            
            let bullet = SPEnemyBullet(color: UIColor.redColor(), size: CGSize(width: 5, height: 15))
            
            bullet.position = self.position
            bullet.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 5, height: 5))
            bullet.physicsBody?.affectedByGravity = false
            bullet.physicsBody?.dynamic = true
            bullet.physicsBody?.collisionBitMask = 0
            bullet.physicsBody?.contactTestBitMask = SPCollisionCategoryBitMask.Player
            bullet.physicsBody?.categoryBitMask = SPCollisionCategoryBitMask.EnemyBullet
            bullet.physicsBody?.velocity.dy = self.physicsBody!.velocity.dy - 500
            bullet.physicsBody?.velocity.dx = 0.0

            self.parent?.addChild(bullet)
        })
        
        parent?.runAction(SKAction.sequence([waitAction,shootAction,waitAction,shootAction]))
    }
    
    func update(currentTime: NSTimeInterval) {
        
        let timeDelta = currentTime - startTime
        
        if timeDelta > enemyStateDuration {
            
            switch state {
                
            case .Idle:
                nextState()
                enemyStateDuration = 0.1
            case .CourseChanging:
                changeCourse()
                nextState()
                enemyStateDuration = 1.5
            case .Shooting:
                shoot()
                nextState()
                enemyStateDuration = 0.6
                
            }
            
            startTime = currentTime
        }
        
        if position.y < 0 {
            
            kill()
        }
    }
    
    func didFinishUpdate() {
        
    }
    
    func checkEnergy() {
        
        if energy <= 0 {
        
            kill()
        }
    }
    
    func kill() {
    
        delegate?.enemyWillDisapper(self)
        
        removeAllActions()
        removeAllChildren()
        removeFromParent()
    }
    
    override func didBeginContact(withNode node: SKNode) {
        
        if node is SPBullet {
            
            if let bullet = node as? SPBullet {
                
                energy -= bullet.damage
                checkEnergy()
                
                bullet.removeFromParent()
            }
        }
    }
}
