//
//  SPScene.swift
//  Space
//
//  Created by Simon Kemper on 27.11.15.
//  Copyright © 2015 Simon Kemper. All rights reserved.
//

import SpriteKit

protocol SPSceneDelegate {
    func update(currentTime: NSTimeInterval)
    func didFinishUpdate()
}

struct SPScreen {
    
    static var Width: CGFloat = 1024.0
    static var Height: CGFloat = 768.0
    
    static func WidthHalf() -> CGFloat {
        
        return Width/2.0
    }
    
    static func HeightHalf() -> CGFloat {
        
        return Height/2.0
    }
}

class SPScene: SKScene {

    func setup() {
        
        SPScreen.Height = size.height
        SPScreen.Width = size.width
    }
}
