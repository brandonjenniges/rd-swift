//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit

struct IntroGraphic {
    
    static let nodeName = String(IntroGraphic)
    
    static func create(scene: SKScene) -> SKSpriteNode? {
        
        guard let view = scene.view else { return nil }
        
        let intro = SKSpriteNode(texture: TextureAtlasManager.introAtlas.textureNamed("tap"))
        intro.name = nodeName
        intro.position = CGPointMake(view.frame.width / 2, view.frame.height / 2)
        intro.zPosition = GameScene.Layer.Hud.rawValue
        
        return intro
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