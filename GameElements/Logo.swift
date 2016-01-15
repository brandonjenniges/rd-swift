//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit

struct Logo {
    
    static let nodeName = "logo"
    
    static func create(scene: SKScene) -> SKSpriteNode? {
        
        guard let view = scene.view else { return nil }
        
        let logo = SKSpriteNode(texture:TextureAtlasManager.introAtlas.textureNamed("logo"))
        logo.name = nodeName
        logo.position = CGPointMake(view.frame.width / 2, view.frame.height * 0.6)
        logo.zPosition = 2
        
        scene.addChild(logo)
        
        let pulseAction =  PulseAnimation.pulseAction(0.05)
        logo.runAction(pulseAction)
        
        return logo
    }
    
    static func getNode(scene: SKScene) -> SKSpriteNode? {
       return scene.childNodeWithName(Logo.nodeName) as? SKSpriteNode
    }
    
}
