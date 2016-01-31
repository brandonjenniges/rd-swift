//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlayingState: GKState {
    unowned let scene: GameScene
    var lastSpawnTimeInterval: NSTimeInterval = 0
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        scene.setupScoreLabel()
        scene.setupDragons()
        
        #if os(iOS)
            scene.setupControlPad()
        #endif
        
        IntroGraphic.remove(scene)
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is GameOverState.Type
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        lastSpawnTimeInterval += seconds
        if lastSpawnTimeInterval > 1 {
            lastSpawnTimeInterval = 0
            scene.addFireball()
        }
        scene.updateScore()
        scene.updateClouds()
    }
    
    // MARK: - State Touches
    
    override func handleTouches(touches: Set<UITouch>, withEvent event: UIEvent?) {
        #if os(iOS)
            scene.control.touchesBegan(touches, withEvent: event)
        #endif
    }
}