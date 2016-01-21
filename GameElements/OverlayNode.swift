//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit

struct OverlayNode {
    
    static let nodeName = String(OverlayNode)
    
    static func create(scene: SKScene) -> SKSpriteNode? {
        
        guard let view = scene.view else { return nil }
        
        let overlay = SKSpriteNode(color: .clearColor(), size: view.frame.size)
        overlay.name = nodeName
        overlay.zPosition = GameScene.Layer.GameOver.rawValue
        return overlay
        
    }
}