//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit

struct GameCenterButton {
    
    static let nodeName = String(GameCenterButton)
    
    static func create(scene: SKScene) -> SKSpriteNode {
        
        let button = SKSpriteNode(texture: TextureAtlasManager.introAtlas.textureNamed("gamecenter"))
        button.zPosition = GameLayer.Layer.Hud.rawValue
        
        return button
    }
    
}