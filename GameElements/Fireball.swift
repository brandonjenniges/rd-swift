//
//  Fireball.swift
//  Launchy Demo
//
//  Created by Brandon Jenniges on 9/27/15.
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit

class Fireball: SKSpriteNode {
    
    static let fireTextureAtlas = SKTextureAtlas(named: "Fire")
    
    func setupFireball() {
        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(setupFireballFrames(), timePerFrame: 0.10)))
    }
    
    private func setupFireballFrames() -> [SKTexture] {
        var array = [SKTexture]()
        array.append(Fireball.fireTextureAtlas.textureNamed("fireball1"))
        array.append(Fireball.fireTextureAtlas.textureNamed("fireball2"))
        array.append(Fireball.fireTextureAtlas.textureNamed("fireball3"))
        array.append(Fireball.fireTextureAtlas.textureNamed("fireball2"))
        return array
    }
    
    func send() {
        let minDuration = 3.0
        let maxDuration = 7.0
        let rangeDuration = UInt32(maxDuration - minDuration)
        let actualDruation = Double(arc4random_uniform(rangeDuration)) + minDuration
        
        let actionMove = SKAction.moveTo(CGPointMake(self.position.x, -self.size.height), duration: actualDruation)
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
        let path = CGPathCreateMutable()
        
        let offsetX = self.frame.size.width * self.anchorPoint.x
        let offsetY = self.frame.size.height * self.anchorPoint.y
        
        
        CGPathMoveToPoint(path, nil, 6 - offsetX, 15 - offsetY)
        CGPathAddLineToPoint(path, nil, 1 - offsetX, 8 - offsetY)
        CGPathAddLineToPoint(path, nil, 1 - offsetX, 3 - offsetY)
        CGPathAddLineToPoint(path, nil, 6 - offsetX, 0 - offsetY)
        CGPathAddLineToPoint(path, nil, 12 - offsetX, 3 - offsetY)
        CGPathAddLineToPoint(path, nil, 11 - offsetX, 10 - offsetY)
        
        CGPathCloseSubpath(path)
        
        self.physicsBody = SKPhysicsBody(polygonFromPath: path)
        self.physicsBody?.categoryBitMask = GameScene.fireballCategory
        self.physicsBody?.contactTestBitMask = GameScene.playerCategory
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.restitution = 0
    }
    
}
