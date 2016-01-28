//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit

struct OverlayNode {
    
    static let nodeName = String(OverlayNode)
    
    static func create(scene: SKScene, score: Int) -> SKSpriteNode? {
        
        guard let view = scene.view else { return nil }
        
        let overlay = SKSpriteNode(color: .clearColor(), size: view.frame.size)
        overlay.name = nodeName
        overlay.zPosition = GameLayer.Layer.GameOver.rawValue
        
        // Scorecard
        
        let scorecard = ScoreBoard(score: score)
        scorecard.position = CGPointMake(0, -view.frame.size.height + -scorecard.frame.size.height)
        overlay.addChild(scorecard)
        let moveAction = SKAction.moveToY(0, duration: 0.4)
        scorecard.runAction(moveAction)
        
        // Gameover label
        
        let gameover = SKSpriteNode(texture: TextureAtlasManager.gameOverAtlas.textureNamed("gameover"))
        gameover.position = CGPointMake(0, view.frame.size.height / 4)
        overlay.addChild(gameover)
        
        // Play button
        
        let playButton = PlayButton.create(scene)!
        playButton.position = CGPointMake(0, -(view.frame.size.height / 4))
        overlay.addChild(playButton)
        
        return overlay
        
    }
}