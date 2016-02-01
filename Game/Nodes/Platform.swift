//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit

struct Platform {
    
    static func create(scene: SKScene) -> SKSpriteNode {
        
        let platform = SKSpriteNode(texture: TextureAtlasManager.sceneAtlas.textureNamed("ground"))
        platform.zPosition = GameLayer.Layer.Foreground.rawValue
        
        #if os(tvOS)
            platform.position = CGPointMake(scene.size.width / 2, platform.size.height)
        #else
            platform.position = CGPointMake(scene.size.width / 2, scene.size.height / 4)
        #endif
        
        return platform
    }
}