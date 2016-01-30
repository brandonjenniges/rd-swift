//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit

struct Background {
    
    static func create(scene: SKScene) -> SKSpriteNode {
        
        let background = SKSpriteNode(color: .backgroundColor(), size: scene.size)
        
        let cloud = SKSpriteNode(texture:TextureAtlasManager.introAtlas.textureNamed("cloud"))
        let numberOfClouds = Int(ceil(scene.size.width / cloud.size.width))
        
        let clouds = SKSpriteNode()
        clouds.anchorPoint = CGPointMake(0.5, 0.5)
        clouds.size = CGSizeMake(CGFloat(numberOfClouds) * cloud.size.width, cloud.size.height)
        
        (1...numberOfClouds).forEach {
            let c = cloud.copy() as! SKSpriteNode
            c.anchorPoint = CGPointMake(0, 0.5)
            c.position = CGPointMake((CGFloat($0 - 1) * c.frame.size.width) - clouds.size.width / 2, 0)
            clouds.addChild(c)
        }
        
        clouds.position = .zero
        background.addChild(clouds)
        
        let bottomClouds = SKSpriteNode(color: .cloudColor(), size: CGSizeMake(scene.size.width, scene.size.height / 2 - clouds.frame.origin.y))
        bottomClouds.position = CGPointMake(0, -(clouds.frame.size.height / 2) - bottomClouds.frame.size.height / 2)
        background.addChild(bottomClouds)
        
        background.position = CGPointMake(scene.size.width / 2, scene.size.height / 2)
        
        return background
    }
}
