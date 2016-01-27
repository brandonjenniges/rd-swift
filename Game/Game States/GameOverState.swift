//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverState: GKState {
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        scene.control.remove()
        let overlay = OverlayNode.create(scene, score: scene.score)!
        scene.background.addChild(overlay)
        scene.player.die()
        scene.reportScoreToGameCenter()
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is IntroState.Type
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
    }
    
    // MARK: - State Touches
    
    override func handleTouches(touches: Set<UITouch>, withEvent event: UIEvent?) {
        scene.restartGame()
    }
}