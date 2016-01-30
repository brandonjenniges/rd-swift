//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit

struct OverlayNode {
    
    static let nodeName = String(OverlayNode)
    
    static func create(scene: SKScene, score: Int) -> SKSpriteNode {
        
        let overlay = SKSpriteNode(color: .clearColor(), size: scene.size)
        overlay.name = nodeName
        overlay.zPosition = GameLayer.Layer.GameOver.rawValue
        overlay.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        
        // Scorecard
        
        let scorecard = ScoreBoard(score: score)
        scorecard.position = CGPointMake(0, -scene.size.height + -scorecard.frame.size.height)
        overlay.addChild(scorecard)
        let moveAction = SKAction.moveToY(0, duration: 0.4)
        scorecard.runAction(moveAction)
        
        // Gameover label
        
        let gameover = SKSpriteNode(texture: TextureAtlasManager.gameOverAtlas.textureNamed("gameover"))
        gameover.position = CGPointMake(0, scene.size.height / 4)
        overlay.addChild(gameover)
        
        // Play button
        
        let playButton = PlayButton.create(scene)
        playButton.position = CGPointMake(0, -(scene.size.height / 4))
        overlay.addChild(playButton)
        
        return overlay
        
    }
}