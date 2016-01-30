//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit

struct PlayButton {
    
    static let nodeName = String(PlayButton)
    
    static func create(scene: SKScene) -> SKSpriteNode {
        
        let playButton = SKSpriteNode(texture: TextureAtlasManager.introAtlas.textureNamed("play"))
        playButton.zPosition = GameLayer.Layer.Hud.rawValue
        
        return playButton
    }
    
    static func press() -> SKTexture {
        return TextureAtlasManager.introAtlas.textureNamed("play-pressed")
    }
    
    static func pressEnded() -> SKTexture {
        return TextureAtlasManager.introAtlas.textureNamed("play")
    }
}