//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit

struct CreditsLogo {
    
    static let nodeName = String(CreditsLogo)
    
    static func create(scene: SKScene) -> SKSpriteNode {
        
        let logo = SKSpriteNode(texture: TextureAtlasManager.introAtlas.textureNamed("created_label"))
        logo.position = CGPointMake(scene.size.width / 2, logo.frame.size.height)
        logo.name = CreditsLogo.nodeName
        
        return logo
    }
    
}