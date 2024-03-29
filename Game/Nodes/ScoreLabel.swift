//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit

struct ScoreLabel {
    
    static let fontName = "DINAlternate-Bold"
    
    static func create(scene: SKScene) -> SKLabelNode? {
        
        let label = SKLabelNode(fontNamed: fontName)
        label.text = "0"
        
        #if os(tvOS)
            label.fontSize = 80.0
            label.position = CGPointMake(scene.size.width / 2, scene.size.height * 0.85)
        #else
            label.fontSize = 30.0
            label.position = CGPointMake(scene.size.width / 2, scene.size.height * 0.75)
        #endif
        
        label.zPosition = GameLayer.Layer.Game.rawValue
        
        return label
        
    }
}
