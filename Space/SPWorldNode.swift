//
//  SPWorldNode.swift
//  Space
//
//  Created by Simon Kemper on 27.11.15.
//  Copyright © 2015 Simon Kemper. All rights reserved.
//

import SpriteKit
import UIKit

class SPWorldNode: SPNode, SPSceneDelegate, SPPlayerSpriteNodeDelegate, SPInputHandlerDelegate, SPEnemyDelegate {

    let playerSpriteNode = SPPlayerSpriteNode(imageNamed: "Ship.png")
    var layers = [SPLayer]()
    
    var spawnRate: NSTimeInterval = 0.5
    var lastTime: NSTimeInterval = 0.0
    
    override func setup() {
     
        func buildStarfield() {
            
            var emitterLayer = SPStarEmitterLayer()
            emitterLayer.parallaxFactor = 2
            emitterLayer.damping = 2+1.5
            emitterLayer.maxAlpha = 1.0
            emitterLayer.minAlpha = 0.3
            emitterLayer.particleScale = 1.0
            emitterLayer.setup()
            emitterLayer.populate(numberOfColumns: 5, numberOfRows: 5)
            
            addChild(emitterLayer)
            layers.append(emitterLayer)
            
            
            emitterLayer = SPStarEmitterLayer()
            emitterLayer.parallaxFactor = 4
            emitterLayer.damping = 2+2.5
            emitterLayer.maxAlpha = 0.8
            emitterLayer.minAlpha = 0.4
            emitterLayer.particleScale = 0.8
            emitterLayer.setup()
            emitterLayer.populate(numberOfColumns: 5, numberOfRows: 5)
            
            addChild(emitterLayer)
            layers.append(emitterLayer)
            
            
            emitterLayer = SPStarEmitterLayer()
            emitterLayer.parallaxFactor = 6
            emitterLayer.damping = 2+3.5
            emitterLayer.maxAlpha = 0.6
            emitterLayer.minAlpha = 0.3
            emitterLayer.particleScale = 0.6
            emitterLayer.setup()
            emitterLayer.populate(numberOfColumns: 5, numberOfRows: 5)
            
            addChild(emitterLayer)
            layers.append(emitterLayer)
            
            
            emitterLayer = SPStarEmitterLayer()
            emitterLayer.parallaxFactor = 8
            emitterLayer.damping = 2+5.0
            emitterLayer.maxAlpha = 0.5
            emitterLayer.minAlpha = 0.3
            emitterLayer.particleScale = 0.4
            emitterLayer.setup()
            emitterLayer.populate(numberOfColumns: 5, numberOfRows: 5)
            
            addChild(emitterLayer)
            layers.append(emitterLayer)
            
            
            emitterLayer = SPStarEmitterLayer()
            emitterLayer.parallaxFactor = 12
            emitterLayer.damping = 2+6.0
            emitterLayer.maxAlpha = 0.4
            emitterLayer.minAlpha = 0.3
            emitterLayer.particleScale = 0.4
            emitterLayer.setup()
            emitterLayer.populate(numberOfColumns: 5, numberOfRows: 5)
            
            addChild(emitterLayer)
            layers.append(emitterLayer)
        }
        
        func setupPlayer() {
            
            playerSpriteNode.setScale(0.2)
            playerSpriteNode.position = CGPoint(x: SPScreen.WidthHalf(), y: SPPlayerSettings.PlayerMarginBottom)
            playerSpriteNode.delegate = self
            playerSpriteNode.setup()
            
            addChild(playerSpriteNode)
        }
        
        buildStarfield()
        setupPlayer()
    }
    
    func createEnemy() {
        
        let xOffset = random(0, max: SPScreen.Width)
        let enemy = SPEnemy()
        
        enemy.position = CGPoint(x: xOffset, y: SPScreen.Height)
        enemy.delegate = self
        enemy.setup()
        
        addChild(enemy)
    }
    
    func enemyWillDisapper(enemy: SPEnemy) {

    }
    
    func didFinishUpdate() {
        
        for node: SKNode in children {
            
            if node is SPSceneDelegate {
                
                // FIXME: Safe Casting nicht erforderlich!
                if let sceneDelegate = node as? SPSceneDelegate {
                    sceneDelegate.didFinishUpdate()
                }
            }
        }
    }
    
    func update(currentTime: NSTimeInterval) {
        
        let deltaTime: NSTimeInterval = currentTime - lastTime
        
        if deltaTime > spawnRate {
            
            createEnemy()
            lastTime = currentTime
            spawnRate = NSTimeInterval(random(0.2, max: 1.0))
        }

        for node: SKNode in children {
            
            if node is SPSceneDelegate {
                
                // FIXME: Safe Casting nicht erforderlich!
                if let sceneDelegate = node as? SPSceneDelegate {
                    sceneDelegate.update(currentTime)
                }
            }
        }
    }
    
    func inputHandlerDidChangeMotion(xAcceleration: CGFloat) {
        playerSpriteNode.inputHandlerDidChangeMotion(xAcceleration)
    }
    
    func inputHandlerDidBeginTouches() {
        playerSpriteNode.inputHandlerDidBeginTouches()
    }
    
    func inputHandlerDidEndTouched() {
        playerSpriteNode.inputHandlerDidEndTouched()
    }
    
    func playerSpriteNodeDidFinishUpdate(playerSpriteNode: SPPlayerSpriteNode) {
        
    }
}
