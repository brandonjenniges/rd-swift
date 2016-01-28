//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit

struct Platform {
    
    static func create(scene: SKScene) -> SKSpriteNode? {
        
        guard let _ = scene.view else { return nil }
        
        let platform = SKSpriteNode(texture: TextureAtlasManager.sceneAtlas.textureNamed("ground"))
        platform.position = CGPointMake(scene.size.width / 2, scene.size.height / 4)
        platform.zPosition = GameLayer.Layer.Foreground.rawValue
        
        return platform
    }
}