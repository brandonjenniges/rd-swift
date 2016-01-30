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
        
        #if os(iOS)
        scene.control.remove()
        #endif
        
        let overlay = OverlayNode.create(scene, score: scene.score)
        scene.worldNode.addChild(overlay)
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
        restartGame()
    }
    
    // MARK: - Restart
    
    func restartGame() {
        let newScene = GameScene(size: scene.size)
        newScene.viewController = scene.viewController
        let transition = SKTransition.fadeWithColor(.blackColor(), duration: 0.02)
        scene.view?.presentScene(newScene, transition: transition)
    }
}