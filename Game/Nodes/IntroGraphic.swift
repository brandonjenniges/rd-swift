//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit

struct IntroGraphic {
    
    static let nodeName = String(IntroGraphic)
    
    static func create(scene: SKScene) -> SKSpriteNode {
        
        let tap = SKSpriteNode(texture: TextureAtlasManager.introAtlas.textureNamed("tap"))
        let point = SKSpriteNode(texture: TextureAtlasManager.introAtlas.textureNamed("point"))
        
        let intro = SKSpriteNode(color: .clearColor(), size: CGSizeMake(max(tap.size.width, point.size.width), tap.size.height + point.size.height))
        intro.name = nodeName
        intro.position = CGPointMake(scene.size.width / 2, scene.size.height / 2)
        intro.zPosition = GameLayer.Layer.Hud.rawValue
        
        tap.position = CGPointMake(0, point.size.height)
        point.position = CGPointMake(0, tap.position.y - tap.size.height - point.size.height / 2)
        
        intro.addChild(tap)
        intro.addChild(point)
        
        return intro
    }
    
    static func remove(scene: GameScene) {
        if let node = scene.worldNode.childNodeWithName(nodeName) as? SKSpriteNode {
            let fadeAction = SKAction.fadeAlphaTo(0, duration: 1.0)
            let removeAction = SKAction.runBlock {
                node.removeFromParent()
            }
            node.runAction(SKAction.sequence([fadeAction, removeAction]))
        }
    }
    
    
}