//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit
import GameplayKit

class IntroState: GKState {
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        scene.addTapToStart()
        scene.createBackground()
        scene.createPlatform()
        scene.setupPlayer()
        FireballEntity.setupGaps(scene.size.width)
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is PlayingState.Type
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
    
    // MARK: - State Touches
    
    override func handleTouches(touches: Set<UITouch>, withEvent event: UIEvent?) {
        scene.gameState.enterState(PlayingState)
    }
}