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
    func controlPadDidEndTouch()
}

class ControlPad: SKSpriteNode {
    
    let left:SKSpriteNode
    let right:SKSpriteNode
    
    var delegate:ControlPadTouches?
    
    init(texture: SKTexture?, size: CGSize) {
        let testImage = ControlPadPaintCodeImage(frame: CGRectMake(0, 0, size.width / 2, size.height))
        let testTexture = SKTexture(image: testImage.getTestImage())
        
        left = SKSpriteNode(texture: testTexture)
        left.anchorPoint = .zero
        left.position = CGPointMake(-left.size.width, -size.height)
        
        right = SKSpriteNode(texture: testTexture)
        right.anchorPoint = .zero
        right.xScale = -1
        right.position = CGPointMake(size.width + right.size.width, -size.height)
        
        super.init(texture: texture, color: .clearColor(), size: size)
        
        self.addChild(left)
        self.addChild(right)
        
        animateInto(.zero, node: left)
        animateInto(CGPointMake(size.width, 0), node: right)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            var currentDirection: ControlPadTouchDirection?
            
            if left.containsPoint(location) {
                left.alpha = 0.5
                currentDirection = .Left
            } else if right.containsPoint(location) {
                right.alpha = 0.5
                currentDirection = .Right
            }
            
            if let delegate = delegate, let direction = currentDirection {
                delegate.controlPadDidBeginTouch(direction)
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        right.alpha = 1
        left.alpha = 1
        
        if let delegate = delegate {
            delegate.controlPadDidEndTouch()
        }
    }
    
    // MARK: - Animation
    
    func animateInto(point: CGPoint, node: SKSpriteNode) {
        let animationAction = SKAction.moveTo(point, duration: 0.8)
        node.runAction(animationAction)
    }
    
}
