//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit

class ScoreBoard: SKSpriteNode {
    
    let bestScoreLabel = SKLabelNode(text: "0")
    let currentScoreLabel = SKLabelNode(text: "0")
    
    init(score:Int) {
        ScoreManager.saveHighScore(score)
        
        let texture = TextureAtlasManager.gameOverAtlas.textureNamed("scorecard")
        super.init(texture: texture, color: .clearColor(), size: texture.size())
        self.zPosition = GameScene.Layer.GameOver.rawValue
        
        currentScoreLabel.text = "\(score)"
        setupLabel(currentScoreLabel)
        currentScoreLabel.position = CGPointMake(-self.size.width * 0.25, -22)
        addChild(currentScoreLabel)
        
        bestScoreLabel.text = "\(ScoreManager.getHighScore())"
        setupLabel(bestScoreLabel)
        bestScoreLabel.position = CGPointMake(self.size.width * 0.25, -22)
        addChild(bestScoreLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabel(label:SKLabelNode) {
        let fontName = "DINAlternate-Bold"
        label.fontName = fontName
        label.horizontalAlignmentMode = .Center
        #if os(tvOS)
            label.fontSize = 55.0
        #else
            label.fontSize = 30.0
        #endif
        label.zPosition = GameScene.Layer.GameOver.rawValue
    }
    
}
