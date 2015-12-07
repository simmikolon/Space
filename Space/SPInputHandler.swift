//
//  SPInputHandler.swift
//  Space
//
//  Created by Simon Kemper on 27.11.15.
//  Copyright © 2015 Simon Kemper. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion

struct SPInputHandlerSettings {
    
    static let AccelerationMultiplier: CGFloat = 2000.0
    static let AccelerometerUpdateInterval = 0.1
}

protocol SPInputHandlerDelegate: class {
    
    func inputHandlerDidChangeMotion(xAcceleration: CGFloat)

    func inputHandlerDidBeginTouches()
    func inputHandlerDidEndTouched()
}

class SPInputHandler {
    
    weak var delegate: SPInputHandlerDelegate?
    
    func setup() {
        
        func setupCoreMotion() {
            
            motionManager.accelerometerUpdateInterval = SPInputHandlerSettings.AccelerometerUpdateInterval
            
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: {
                (accelerometerData: CMAccelerometerData?, error: NSError?) in
                
                let acceleration = accelerometerData!.acceleration
                self.xAcceleration = (CGFloat(acceleration.x) * 0.75) + (self.xAcceleration * 0.25)
                let xAcceleration = self.xAcceleration * SPInputHandlerSettings.AccelerationMultiplier
                
                self.delegate?.inputHandlerDidChangeMotion(xAcceleration)
            })
        }
        
        setupCoreMotion()
    }
    
    let motionManager = CMMotionManager()
    var xAcceleration: CGFloat = 0.0
    
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?, andView view: SKView?) {
        
        delegate?.inputHandlerDidBeginTouches()
    }
    
    func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?, andView view: SKView?) {
        
    }
    
    func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?, andView view: SKView?) {
        
        delegate?.inputHandlerDidEndTouched()
    }
}
