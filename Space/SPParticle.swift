//
//  SPParticle.swift
//  Space
//
//  Created by Simon Kemper on 27.11.15.
//  Copyright © 2015 Simon Kemper. All rights reserved.
//

import SpriteKit

class SPParticle: SPSpriteNode {

    var column: Int = 0
    var damping = CGFloat(20.0)
    var maxAlpha = CGFloat(1.0)
    var minAlpha = CGFloat(0.5)
    
    override func setup() {
        
        let body = SKPhysicsBody(rectangleOfSize: CGSize(width: 2.5, height: 2.5))
        body.affectedByGravity = true
        body.mass = 0.001
        body.linearDamping = damping
        body.collisionBitMask = 0
        body.contactTestBitMask = 0
        body.categoryBitMask = 0
        physicsBody = body
        
        let newAlpha = random(minAlpha, max: maxAlpha)
        
        alpha = newAlpha
        
        let duration: CGFloat = random(0.0, max: 5.0)
        let delayAction = SKAction.waitForDuration(NSTimeInterval(duration))
        
        let fadeMaxAction = SKAction.fadeAlphaTo(maxAlpha, duration: 0.75)
        let fadeMinAction = SKAction.fadeAlphaTo(minAlpha, duration: 0.75)
        
        fadeMinAction.timingMode = SKActionTimingMode.EaseOut
        fadeMaxAction.timingMode = SKActionTimingMode.EaseIn
        
        let sequence = SKAction.sequence([fadeMaxAction, fadeMinAction])
        let repeation = SKAction.repeatActionForever(sequence)
        
        runAction(delayAction) { () -> Void in
            self.runAction(repeation)
        }
    }
}
