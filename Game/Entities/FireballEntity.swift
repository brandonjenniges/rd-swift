//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit
import GameplayKit

class FireballEntity: GKEntity {
    
    var spriteComponent: SpriteComponent!
    
    // MARK: - Initializers
    
    override init() {
        super.init()
        
        let texture = TextureAtlasManager.fireTextureAtlas.textureNamed("fireball1")
        
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)
        
        setupFireball()
        setupPhysicsBody()
        spriteComponent.node.zPosition = GameScene.Layer.Game.rawValue
    }
    
    // MARK: - Physics
    
    private func setupPhysicsBody() {
        spriteComponent.node.physicsBody = SKPhysicsBody(circleOfRadius: spriteComponent.node.size.width / 2)
        if let physicsBody = spriteComponent.node.physicsBody {
            physicsBody.categoryBitMask = PhysicsCategory.Fireball
            physicsBody.contactTestBitMask = PhysicsCategory.Player
            physicsBody.collisionBitMask = PhysicsCategory.None
            physicsBody.affectedByGravity = false
            physicsBody.restitution = 0
        }
    }
    
    // MARK: - Positioning
    
    func setInitialPosition(gaps:[CGFloat], background: SKSpriteNode) {
        let x = gaps[Int(arc4random_uniform(UInt32(gaps.count - 1)))] + spriteComponent.node.size.width / 2
        spriteComponent.node.position = CGPointMake(x - background.frame.size.width / 2, background.frame.size.height + background.frame.size.height / 2.0)
    }
    
    // MARK: - Animation
    
    private func setupFireball() {
        spriteComponent.node.name = String(FireballEntity)
        spriteComponent.node.userData = NSMutableDictionary()
        spriteComponent.node.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(setupFireballFrames(), timePerFrame: 0.10)))
    }
    
    private func setupFireballFrames() -> [SKTexture] {
        return [
            TextureAtlasManager.fireTextureAtlas.textureNamed("fireball1"),
            TextureAtlasManager.fireTextureAtlas.textureNamed("fireball2"),
            TextureAtlasManager.fireTextureAtlas.textureNamed("fireball3"),
            TextureAtlasManager.fireTextureAtlas.textureNamed("fireball2")
        ]
    }
    
    // MARK: - Movement
    
    func send(toYPos:CGFloat) {
        let minDuration = 3.0
        let maxDuration = 7.0
        let rangeDuration = UInt32(maxDuration - minDuration)
        let actualDruation = Double(arc4random_uniform(rangeDuration)) + minDuration
        
        let actionMove = SKAction.moveTo(CGPointMake(spriteComponent.node.position.x, toYPos - spriteComponent.node.size.height), duration: actualDruation)
        let doneAction = SKAction.removeFromParent()
        spriteComponent.node.runAction(SKAction.sequence([actionMove, doneAction]))
    }
    
}
