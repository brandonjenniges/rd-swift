//
//  Player.swift
//  Launchy Demo
//
//  Created by Brandon Jenniges on 9/26/15.
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    static let playerAtlas = SKTextureAtlas(named: "Player")
    let lookingAction = "lookingAction"
    let runningAnimation = "runningAnimation"
    let moveAction = "moveAction"
    
    enum PlayerMovement {
        case Neutral
        case Left
        case Right
    }
    
    var movement:PlayerMovement?
    var maxRight:CGFloat?
    var maxLeft:CGFloat?
    var previousPlayerTouch:CGFloat?
    
    private func setupLookingFrames() -> [SKTexture] {
        var array = [SKTexture]()
        array.append(Player.playerAtlas.textureNamed("looking_right"))
        array.append(Player.playerAtlas.textureNamed("player0"))
        array.append(Player.playerAtlas.textureNamed("looking_left"))
        array.append(Player.playerAtlas.textureNamed("player0"))
        return array
    }
    
    private func setupRunningFrames() -> [SKTexture] {
        var array = [SKTexture]()
        array.append(Player.playerAtlas.textureNamed("player1"))
        array.append(Player.playerAtlas.textureNamed("player2"))
        array.append(Player.playerAtlas.textureNamed("player3"))
        array.append(Player.playerAtlas.textureNamed("player4"))
        array.append(Player.playerAtlas.textureNamed("player5"))
        array.append(Player.playerAtlas.textureNamed("player6"))
        array.append(Player.playerAtlas.textureNamed("player5"))
        array.append(Player.playerAtlas.textureNamed("player4"))
        array.append(Player.playerAtlas.textureNamed("player3"))
        array.append(Player.playerAtlas.textureNamed("player2"))
        return array
    }
    
    func setPlayerRightMovementMax(max:CGFloat, min:CGFloat) {
        self.maxRight = max
        self.maxLeft = min
    }
    
    func runPlayerLookingAnimation() {
        let delayAction = SKAction.waitForDuration(3.0)
        self.runAction(delayAction) { () -> Void in
            let lookAction = SKAction.animateWithTextures(self.setupLookingFrames(), timePerFrame: 1.0, resize: false, restore: true)
            let sequence = SKAction.sequence([lookAction])
            sequence.timingMode = .EaseInEaseOut
            self.runAction(SKAction.repeatActionForever(sequence), withKey: self.lookingAction)
        }
    }
    
    func getSpeed(moveTo:CGFloat) -> Double {
        let moveDiff = CGPointMake(moveTo - self.position.x, 0.0)
        return Double(sqrtf(Float(moveDiff.x) * Float(moveDiff.x)) / Float(scene!.frame.size.width / 3))
    }
    
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
    
    func performRunAnimation() {
        let runAction = SKAction.animateWithTextures(self.setupRunningFrames(), timePerFrame: 0.1, resize: false, restore: true)
        let sequence = SKAction.sequence([runAction])
        sequence.timingMode = .EaseInEaseOut
        self.runAction(SKAction.repeatActionForever(sequence),withKey: runningAnimation)
    }
    
    func setupPhysicsBody() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.frame.width / 2)
        self.physicsBody?.categoryBitMask = GameScene.playerCategory
        self.physicsBody?.contactTestBitMask = GameScene.fireballCategory
        self.physicsBody?.collisionBitMask = 0
        
        self.physicsBody?.angularVelocity = 0
        self.physicsBody?.restitution = 0
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = false
        
    
    }
    
    func stopRunning() {
        self.removeActionForKey(self.runningAnimation)
        self.removeActionForKey(self.moveAction)
        self.texture = SKTexture(imageNamed: "player0")
        self.runPlayerLookingAnimation()
    }
    
    func die() {
        stopRunning()
    }
    
}