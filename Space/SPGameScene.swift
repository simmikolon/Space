//
//  SPGameScene.swift
//  Space
//
//  Created by Simon Kemper on 27.11.15.
//  Copyright © 2015 Simon Kemper. All rights reserved.
//

import SpriteKit

class SPGameScene: SPScene, SPInputHandlerDelegate {

    let inputHandler = SPInputHandler()
    let worldNode = SPWorldNode()
    let contactHandler = SPPhysicsWorldContactHandler()
    
    override func setup() {
        
        super.setup()
        
        func setupContactHandler() {
            
            self.physicsWorld.contactDelegate = contactHandler
        }
        
        func setupInputHandler() {
            
            inputHandler.delegate = self
            inputHandler.setup()
        }
        
        func setupScene() {
            
            backgroundColor = SKColor.blackColor()
            //anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }
        
        func setupWorldNode() {
            
            addChild(worldNode)
            worldNode.setup()
        }
        
        setupContactHandler()
        setupInputHandler()
        setupScene()
        setupWorldNode()
    }
    
    override func update(currentTime: NSTimeInterval) {
        worldNode.update(currentTime)
    }
    
    override func didFinishUpdate() {
        worldNode.didFinishUpdate()
    }
    
    func inputHandlerDidChangeMotion(xAcceleration: CGFloat) {
        worldNode.inputHandlerDidChangeMotion(xAcceleration)
    }
    
    func inputHandlerDidBeginTouches() {
        worldNode.inputHandlerDidBeginTouches()
    }
    
    func inputHandlerDidEndTouched() {
        worldNode.inputHandlerDidEndTouched()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        inputHandler.touchesBegan(touches, withEvent: event, andView: self.view)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        inputHandler.touchesMoved(touches, withEvent: event, andView: self.view)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        inputHandler.touchesEnded(touches, withEvent: event, andView: self.view)
    }
}
