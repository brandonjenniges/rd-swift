//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit

class PulseAnimation: SKAction {
    
    static func pulseAction(pulseScale: CGFloat, duration sec: NSTimeInterval) -> SKAction {
        return PulseAnimation.pulseAction(1.0, scale: pulseScale, duration: sec)
    }
    
    static func pulseAction(pulseScale: CGFloat) -> SKAction {
        return PulseAnimation.pulseAction(1.0, scale: pulseScale, duration: 1)
    }
    
    static func pulseAction(startScale: CGFloat, scale pulseScale: CGFloat) -> SKAction {
       return PulseAnimation.pulseAction(startScale, scale: pulseScale, duration: 1)
    }
    
    static func pulseAction(startScale: CGFloat, scale pulseScale: CGFloat, duration sec: NSTimeInterval) -> SKAction {
        let growAction = SKAction.scaleTo(startScale + pulseScale, duration: sec)
        growAction.timingMode = .EaseInEaseOut
        let shrinkAction = SKAction.scaleTo(startScale - pulseScale, duration: sec)
        shrinkAction.timingMode = .EaseInEaseOut
        let sequence = SKAction.sequence([growAction, shrinkAction])
        let repeatAction = SKAction.repeatActionForever(sequence)
        return repeatAction
    }

}
