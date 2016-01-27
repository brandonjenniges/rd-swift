//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit

struct CreditsLogo {
    
    static let nodeName = String(CreditsLogo)
    
    static func create(scene: SKScene) -> SKSpriteNode? {
        
        guard let view = scene.view else { return nil }
        
        let logo = SKSpriteNode(texture: TextureAtlasManager.introAtlas.textureNamed("created_label"))
        logo.position = CGPointMake(view.frame.size.width / 2, logo.frame.size.height)
        scene.addChild(logo)
        
        return logo
    }
    
    static func remove(scene: SKScene) {
        if let node = scene.childNodeWithName(nodeName) as? SKSpriteNode {
            let fadeAction = SKAction.fadeAlphaTo(0, duration: 1.0)
            let removeAction = SKAction.runBlock {
                node.removeFromParent()
            }
            node.runAction(SKAction.sequence([fadeAction, removeAction]))
        }
    }
    
    
}