//
//  ScoreLabel.swift
//  Rampaging Dragons
//
//  Created by Brandon Jenniges on 10/12/15.
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit

class ScoreLabel: SKLabelNode {
    static let fontName = "SanFranciscoDisplay-Bold"
    
    override init() {
        super.init()
        self.fontName = ScoreLabel.fontName
        self.text = "0"
        self.zPosition = GameScene.Layer.Game.rawValue
        
        #if os(tvOS)
            self.fontSize = 55.0
        #else
            self.fontSize = 30.0
        #endif
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
