//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit

class Fireball: SKSpriteNode {
    
    func setupFireball() {
        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(setupFireballFrames(), timePerFrame: 0.10)))
    }
    
    private func setupFireballFrames() -> [SKTexture] {
        let array = [
            TextureAtlasManager.fireTextureAtlas.textureNamed("fireball1"),
            TextureAtlasManager.fireTextureAtlas.textureNamed("fireball2"),
            TextureAtlasManager.fireTextureAtlas.textureNamed("fireball3"),
            TextureAtlasManager.fireTextureAtlas.textureNamed("fireball2")
        ]
        return array
    }
    
    func send(toYPos:CGFloat) {
        let minDuration = 3.0
        let maxDuration = 7.0
        let rangeDuration = UInt32(maxDuration - minDuration)
        let actualDruation = Double(arc4random_uniform(rangeDuration)) + minDuration
        
        let actionMove = SKAction.moveTo(CGPointMake(self.position.x, toYPos - self.size.height), duration: actualDruation)
        let scoreAction = SKAction.runBlock { () -> Void in
            if let scene = self.scene as? GameScene {
                if scene.gameState == .Play {
                    scene.increaseScore()
                }
            }
        }
        let doneAction = SKAction.removeFromParent()
        self.runAction(SKAction.sequence([actionMove, scoreAction, doneAction]))
        
    }
    
    func setupPhysicsBody() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.frame.width / 2)
        self.physicsBody?.categoryBitMask = GameScene.fireballCategory
        self.physicsBody?.contactTestBitMask = GameScene.playerCategory
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.restitution = 0
    }
    
}
