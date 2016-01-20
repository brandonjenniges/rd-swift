//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit

struct Platform {
    
    static func create(scene: SKScene) -> SKSpriteNode? {
        
        guard let view = scene.view else { return nil }
        
        let platform = SKSpriteNode(texture: TextureAtlasManager.sceneAtlas.textureNamed("ground"))
        platform.position = CGPointMake(view.frame.width / 2, view.frame.height / 4)
        platform.zPosition = GameScene.Layer.Foreground.rawValue
        
        scene.addChild(platform)
        
        if let mountain = Mountain.create(scene, platform: platform) {
            scene.addChild(mountain)
        }
        
        return platform
    }
}