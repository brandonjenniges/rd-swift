//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlayerEntity: GKEntity {
    
    static let nodeName = String(PlayerEntity)
    
    enum PlayerMovement { case Neutral; case Left; case Right }
    
    var spriteComponent: SpriteComponent!
    
    var movement:PlayerMovement
    var maxRight:CGFloat?
    var maxLeft:CGFloat?
    var previousPlayerTouch:CGFloat?
    
    override init() {
        self.movement = .Neutral
        super.init()
        
        let texture = TextureAtlasManager.player_0
        
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)
        
        spriteComponent.node.zPosition = GameLayer.Layer.Game.rawValue
        
        // Setup
        runPlayerLookingAnimation()
        setupPhysics()
    }
    
    // MARK: - Animation frames
    
    private func setupLookingFrames() -> [SKTexture] {
        let array = [
            TextureAtlasManager.player_looking_right,
            TextureAtlasManager.player_0,
            TextureAtlasManager.player_looking_left,
            TextureAtlasManager.player_0
        ]
        return array
    }
    
    private func setupRunningFrames() -> [SKTexture] {
        let array = [
            TextureAtlasManager.player_1,
            TextureAtlasManager.player_2,
            TextureAtlasManager.player_3,
            TextureAtlasManager.player_4,
            TextureAtlasManager.player_5,
            TextureAtlasManager.player_6,
            TextureAtlasManager.player_5,
            TextureAtlasManager.player_4,
            TextureAtlasManager.player_3,
            TextureAtlasManager.player_2
        ]
        return array
    }
    
    // MARK: - Animations
    
    func runPlayerLookingAnimation() {
        let delayAction = SKAction.waitForDuration(3.0)
        self.spriteComponent.node.runAction(delayAction) {
            let lookAction = SKAction.animateWithTextures(self.setupLookingFrames(), timePerFrame: 1.0, resize: false, restore: true)
            let sequence = SKAction.sequence([lookAction])
            sequence.timingMode = .EaseInEaseOut
            self.spriteComponent.node.runAction(SKAction.repeatActionForever(sequence))
        }
    }
    
    func performRunAnimation() {
        let runAction = SKAction.animateWithTextures(self.setupRunningFrames(), timePerFrame: 0.07, resize: false, restore: true)
        let sequence = SKAction.sequence([runAction])
        sequence.timingMode = .EaseInEaseOut
        self.spriteComponent.node.runAction(SKAction.repeatActionForever(sequence))
    }
    
    func stopRunning() {
        movement = .Neutral
        self.spriteComponent.node.removeAllActions()
        self.spriteComponent.node.texture = TextureAtlasManager.player_0
        self.runPlayerLookingAnimation()
    }
    
    // MARK: - Physics
    
    func setupPhysics() {
        self.spriteComponent.node.physicsBody = SKPhysicsBody(circleOfRadius: self.spriteComponent.node.frame.width / 2)
        self.spriteComponent.node.physicsBody!.categoryBitMask = PhysicsCategory.Player
        self.spriteComponent.node.physicsBody!.contactTestBitMask = PhysicsCategory.Fireball
        self.spriteComponent.node.physicsBody!.collisionBitMask = PhysicsCategory.None
        
        self.spriteComponent.node.physicsBody!.angularVelocity = 0
        self.spriteComponent.node.physicsBody!.restitution = 0
        self.spriteComponent.node.physicsBody!.allowsRotation = false
        self.spriteComponent.node.physicsBody!.affectedByGravity = false
    }
    
    // MARK: - Movement
    
    func movePlayer(touches: Set<UITouch>) {
        for touch in touches {
            let touchPoint = touch.locationInNode(self.spriteComponent.node.scene!)
            if movement == .Neutral {
                if touchPoint.x > previousPlayerTouch {
                    moveRight()
                } else {
                    moveLeft()
                }
                previousPlayerTouch = touchPoint.x
            } else if movement == .Left {
                if touchPoint.x > previousPlayerTouch {
                    moveRight()
                }
                previousPlayerTouch = touchPoint.x
            } else {
                if touchPoint.x < previousPlayerTouch {
                    moveLeft()
                }
                previousPlayerTouch = touchPoint.x
            }
        }
        
    }
    
    func movePlayer(direction: ControlPadTouchDirection) {
        if movement == .Neutral {
            if direction == .Left {
                moveLeft()
            } else if direction == .Right {
                moveRight()
            }
        } else if movement == .Left {
            if direction == .Right {
                moveRight()
            }
        } else if movement == .Right {
            if direction == .Left {
                moveLeft()
            }
        }
    }
    
    func moveLeft() {
        if let moveTo = maxLeft {
            let moveAction = SKAction.moveToX(moveTo, duration: self.getSpeed(moveTo))
            let completionAction = getRunningCompletionAction()
            let sequenceAction = SKAction.sequence([moveAction, completionAction])
            movement = .Left
            self.spriteComponent.node.removeAllActions()
            self.spriteComponent.node.runAction(sequenceAction)
            self.spriteComponent.node.xScale = abs(self.spriteComponent.node.xScale)
            self.performRunAnimation()
        }
    }
    
    func moveRight() {
        if let moveTo = maxRight {
            let moveAction = SKAction.moveToX(moveTo, duration: self.getSpeed(moveTo))
            let completionAction = getRunningCompletionAction()
            let sequenceAction = SKAction.sequence([moveAction, completionAction])
            movement = .Right
            self.spriteComponent.node.removeAllActions()
            self.spriteComponent.node.runAction(sequenceAction)
            self.spriteComponent.node.xScale = -abs(self.spriteComponent.node.xScale)
            self.performRunAnimation()
        }
    }
    
    // MARK: - Movement utilities
    
    func setPlayerMovementXConstraints(max:CGFloat, min:CGFloat) {
        self.maxRight = max
        self.maxLeft = min
    }
    
    func getSpeed(moveTo:CGFloat) -> Double {
        let moveDiff = CGPointMake(moveTo - self.spriteComponent.node.position.x, 0.0)
        return Double(sqrtf(Float(moveDiff.x) * Float(moveDiff.x)) / Float(self.spriteComponent.node.scene!.frame.size.width / 3))
    }
    
    func die() {
        stopRunning()
    }
    
    func getRunningCompletionAction() -> SKAction {
        return SKAction.runBlock({
            #if os(iOS)
                if (self.spriteComponent.node.scene! as! GameScene).gameState.currentState is PlayingState {
                    self.stopRunning()
                    self.movement = .Neutral
                }
            #endif
        })
    }
    
}