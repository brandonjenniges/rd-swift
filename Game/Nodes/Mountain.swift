//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//


import SpriteKit

struct Mountain {
    
    static func create(scene: SKScene, platform: SKSpriteNode) -> SKSpriteNode? {
        
        guard let view = scene.view else { return nil }
        
        let mountain = SKSpriteNode(texture: TextureAtlasManager.sceneAtlas.textureNamed("mountain"))
        mountain.position = CGPointMake(view.frame.width / 2, platform.position.y + mountain.size.height / 2 + platform.size.height / 2)
        mountain.zPosition = GameLayer.Layer.Foreground.rawValue
        
        return mountain
    }
}