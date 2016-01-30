//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit

struct Button {
    
    static let nodeName = String(Button)
    
    static func create(scene: SKScene) -> SKSpriteNode {
        
        let button = SKSpriteNode(texture: TextureAtlasManager.introAtlas.textureNamed("button"))
        button.zPosition = GameLayer.Layer.Hud.rawValue
        
        return button
    }
    
    static func press() -> SKTexture {
        return TextureAtlasManager.introAtlas.textureNamed("button-pressed")
    }
    
    static func pressEnded() -> SKTexture {
        return TextureAtlasManager.introAtlas.textureNamed("button")
    }
}