//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit

protocol FireballDelegate {
    func fireballDidReachDestination()
}

class Fireball: SKSpriteNode {
    
    var delegate: FireballDelegate?
    
    // MARK: - Initializers
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        setupFireball()
        setupPhysicsBody()
        zPosition = CGFloat(GameScene.Layer.Game.rawValue)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Physics
    
    private func setupPhysicsBody() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.frame.width / 2)
        if let physicsBody = self.physicsBody {
            physicsBody.categoryBitMask = GameScene.fireballCategory
            physicsBody.contactTestBitMask = GameScene.playerCategory
            physicsBody.collisionBitMask = 0
            physicsBody.affectedByGravity = false
            physicsBody.restitution = 0
        }
    }
    
    // MARK: - Positioning
    
    func setInitialPosition(gaps:[CGFloat], background: SKSpriteNode) {
        let x = gaps[Int(arc4random_uniform(UInt32(gaps.count - 1)))] + size.width / 2
        self.position = CGPointMake(x - background.frame.size.width / 2, background.frame.size.height + background.frame.size.height / 2.0)
    }
    
    // MARK: - Animation
    
    private func setupFireball() {
        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(setupFireballFrames(), timePerFrame: 0.10)))
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
        
        let actionMove = SKAction.moveTo(CGPointMake(self.position.x, toYPos - self.size.height), duration: actualDruation)
        let scoreAction = SKAction.runBlock { () -> Void in
            if let delegate = self.delegate {
                delegate.fireballDidReachDestination()
            }
        }
        let doneAction = SKAction.removeFromParent()
        self.runAction(SKAction.sequence([actionMove, scoreAction, doneAction]))
        
    }
    
}
