//
//  SPStarEmitterLayer.swift
//  Space
//
//  Created by Simon Kemper on 27.11.15.
//  Copyright © 2015 Simon Kemper. All rights reserved.
//

import SpriteKit

func random(firstNum: CGFloat, max secondNum: CGFloat) -> CGFloat{
    return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
}

class SPStarEmitterLayer: SPEmitterLayer {

    var minAlpha = CGFloat(1.0)
    var maxAlpha = CGFloat(1.0)
    var particleScale = CGFloat(1.0)
    
    var columnOffset = CGFloat(0.0)
    var rowOffset = CGFloat(0.0)
    var damping = CGFloat(0.0)

    func populate(numberOfColumns numColumns: Int, numberOfRows numRows: Int) {
        
        columnOffset = SPScreen.Width / CGFloat(numColumns)
        rowOffset = SPScreen.Height / CGFloat(numRows)
        
        for var column = 0; column < numColumns; ++column {
            
            for var row = 0; row < numRows; ++row {
                
                var xPos = columnOffset * CGFloat(column)
                var yPos = rowOffset * CGFloat(row)
                
                xPos = random(xPos, max: xPos + columnOffset)
                yPos = random(yPos, max: yPos + rowOffset)
                
                let particle = SPParticle(color: SKColor.whiteColor(), size: CGSize(width: 5.0, height: 5.0))
                particle.damping = damping
                particle.minAlpha = minAlpha
                particle.maxAlpha = maxAlpha
                particle.setup()
                particle.position = CGPoint(x: xPos, y: yPos)
                particle.column = column
                particle.setScale(particleScale)
                addChild(particle)
            }
        }
        
    }
    
    override func setup() {
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        for node: SKNode in children {
            
            let particleNode = node as! SPParticle
            
            if node.position.y < 0 {
                
                var xPos = columnOffset * CGFloat(particleNode.column)
                let yPos = SPScreen.Height
                
                xPos = random(xPos, max: xPos + columnOffset)
                particleNode.position = CGPoint(x: xPos, y: yPos)
            }
        }
    }
    
    override func didFinishUpdate() {
        
    }
}
