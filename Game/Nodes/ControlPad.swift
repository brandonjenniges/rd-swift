//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit

enum ControlPadTouchDirection {
    case None
    case Left
    case Right
}

protocol ControlPadTouches {
    func controlPadDidBeginTouch(direction: ControlPadTouchDirection)
}

class ControlPad: SKSpriteNode {
    
    let left:SKSpriteNode
    let right:SKSpriteNode
    
    let regularTexture = TextureAtlasManager.sceneAtlas.textureNamed("control")
    let pressedTexture = TextureAtlasManager.sceneAtlas.textureNamed("control-pressed")
    
    var delegate:ControlPadTouches?
    
    init(texture: SKTexture?, size: CGSize) {
        
        left = SKSpriteNode(texture: texture)
        left.anchorPoint = .zero
        left.position = CGPointMake(-left.size.width, -size.height)
        
        right = SKSpriteNode(texture: texture)
        right.anchorPoint = .zero
        right.xScale = -1
        right.position = CGPointMake(size.width + right.size.width, -size.height)
        
        super.init(texture: nil, color: .clearColor(), size: size)
        
        addChild(left)
        addChild(right)
        
        zPosition = GameLayer.Layer.Hud.rawValue
        
        animateInto(.zero, node: left)
        animateInto(CGPointMake(size.width, 0), node: right)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func remove() {
        removeFromParent()
    }
    
    // MARK: - Touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            var currentDirection: ControlPadTouchDirection?
            
            if left.containsPoint(location) {
                left.texture = pressedTexture
                currentDirection = .Left
            } else if right.containsPoint(location) {
                right.texture = pressedTexture
                currentDirection = .Right
            }
            
            if let delegate = delegate, let direction = currentDirection {
                delegate.controlPadDidBeginTouch(direction)
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        left.texture = regularTexture
        right.texture = regularTexture
    }
    
    // MARK: - Animation
    
    func animateInto(point: CGPoint, node: SKSpriteNode) {
        let animationAction = SKAction.moveTo(point, duration: 0.8)
        node.runAction(animationAction)
    }
    
}
