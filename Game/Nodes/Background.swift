//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit

struct Background {
    
    static func create(scene: SKScene) -> SKSpriteNode {
        
        let background = SKSpriteNode(color: .backgroundColor(), size: scene.size)
        
        let cloud = SKSpriteNode(texture:TextureAtlasManager.introAtlas.textureNamed("cloud"))
        cloud.name = "cloud"
        let numberOfClouds = Int(scene.size.width / cloud.size.width) + 2
        
        for i in 0..<numberOfClouds {
            let c = cloud.copy() as! SKSpriteNode
            c.anchorPoint = CGPointMake(0.0, 1.0)
            c.position = CGPoint(x: CGFloat(i) * c.size.width - scene.size.width / 2, y: 0)
            background.addChild(c)
        }
        
        let bottomClouds = SKSpriteNode(color: .cloudColor(), size: CGSizeMake(scene.size.width, scene.size.height / 2))
        bottomClouds.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        bottomClouds.position = CGPointMake(0, -cloud.size.height)
        background.addChild(bottomClouds)
        
        background.position = CGPointMake(scene.size.width / 2, scene.size.height / 2)
        
        return background
    }
}
