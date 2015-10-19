//
//  ScoreBoard.swift
//  Rampaging Dragons
//
//  Created by Brandon Jenniges on 9/30/15.
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit

class ScoreBoard: SKSpriteNode {
    
    let bestScoreLabel = SKLabelNode(text: "0")
    let currentScoreLabel = SKLabelNode(text: "0")
    
    init(score:Int) {
        ScoreManager.saveHighScore(score)
        
        let texture = TextureAtlasManager.gameOverAtlas.textureNamed("scorecard")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.zPosition = GameScene.Layer.GameOver.rawValue
        
        currentScoreLabel.position = CGPointMake(-111, -22)
        currentScoreLabel.text = "\(score)"
        setupLabel(currentScoreLabel)
        addChild(currentScoreLabel)
        
        bestScoreLabel.position = CGPointMake(100, -22)
        bestScoreLabel.text = "\(ScoreManager.getHighScore())"
        setupLabel(bestScoreLabel)
        addChild(bestScoreLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabel(label:SKLabelNode) {
        let fontName = "SanFranciscoDisplay-Bold"
        label.fontName = fontName
        
        #if os(tvOS)
            label.fontSize = 55.0
        #else
            label.fontSize = 30.0
        #endif
        label.zPosition = GameScene.Layer.GameOver.rawValue
    }
    
}
