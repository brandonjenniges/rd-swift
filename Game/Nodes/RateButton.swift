//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit

struct RateButton {
    
    static let nodeName = String(RateButton)
    
    static func create(scene: SKScene) -> SKSpriteNode {
        
        let button = SKSpriteNode(texture: TextureAtlasManager.introAtlas.textureNamed("rate"))
        button.zPosition = GameLayer.Layer.Hud.rawValue
        
        return button
    }
    
}