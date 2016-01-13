//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    let lookingAction = "lookingAction"
    let runningAnimation = "runningAnimation"
    let moveAction = "moveAction"
    let PlayerCategoryName = "player"
    
    enum PlayerMovement { case Neutral; case Left; case Right }
    
    var movement:PlayerMovement
    var maxRight:CGFloat?
    var maxLeft:CGFloat?
    var previousPlayerTouch:CGFloat?
    
    init() {
        self.movement = .Neutral
        let texture = TextureAtlasManager.player_0
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.name = PlayerCategoryName
        self.zPosition = GameScene.Layer.Game.rawValue
        setupPhysics()
        self.runPlayerLookingAnimation()
        self.setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        self.runAction(delayAction) { () -> Void in
            let lookAction = SKAction.animateWithTextures(self.setupLookingFrames(), timePerFrame: 1.0, resize: false, restore: true)
            let sequence = SKAction.sequence([lookAction])
            sequence.timingMode = .EaseInEaseOut
            self.runAction(SKAction.repeatActionForever(sequence), withKey: self.lookingAction)
        }
    }
    
    func performRunAnimation() {
        let runAction = SKAction.animateWithTextures(self.setupRunningFrames(), timePerFrame: 0.1, resize: false, restore: true)
        let sequence = SKAction.sequence([runAction])
        sequence.timingMode = .EaseInEaseOut
        self.runAction(SKAction.repeatActionForever(sequence),withKey: runningAnimation)
    }
    
    func stopRunning() {
        self.removeActionForKey(self.runningAnimation)
        self.removeActionForKey(self.moveAction)
        self.texture = TextureAtlasManager.player_0
        self.runPlayerLookingAnimation()
    }
    
    // MARK: - Physics
    
    func setupPhysics() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.frame.width / 2)
        self.physicsBody?.categoryBitMask = GameScene.playerCategory
        self.physicsBody?.contactTestBitMask = GameScene.fireballCategory
        self.physicsBody?.collisionBitMask = 0
        
        self.physicsBody?.angularVelocity = 0
        self.physicsBody?.restitution = 0
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = false
    }
    
    // MARK: - Movement
    
    func movePlayer(touches: Set<UITouch>) {
        for touch in touches {
            let touchPoint = touch.locationInNode(self.scene!)
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
    
    func moveLeft() {
        if let moveTo = maxLeft {
            let moveAction = SKAction.moveToX(moveTo, duration: self.getSpeed(moveTo))
            movement = .Left
            self.removeAllActions()
            self.runAction(moveAction, withKey: self.moveAction)
            self.xScale = abs(self.xScale)
            self.performRunAnimation()
        }
    }
    
    func moveRight() {
        if let moveTo = maxRight {
            let moveAction = SKAction.moveToX(moveTo, duration: self.getSpeed(moveTo))
            movement = .Right
            self.removeAllActions()
            self.runAction(moveAction, withKey: self.moveAction)
            self.xScale = -abs(self.xScale)
            self.performRunAnimation()
        }
    }
    
    // MARK: - Movement utilities
    
    func setPlayerRightMovementMax(max:CGFloat, min:CGFloat) {
        self.maxRight = max
        self.maxLeft = min
    }
    
    func getSpeed(moveTo:CGFloat) -> Double {
        let moveDiff = CGPointMake(moveTo - self.position.x, 0.0)
        return Double(sqrtf(Float(moveDiff.x) * Float(moveDiff.x)) / Float(scene!.frame.size.width / 3))
    }
    
    func die() {
        stopRunning()
    }
    
}