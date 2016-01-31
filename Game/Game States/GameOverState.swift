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
        
        scene.setupScoreCard()
        scene.setupGameOverLabel()
        scene.setupPlayButton()
        
        #if os(iOS)
            scene.setupGameCenterButton()
            scene.setupRateButton()
        #endif
        
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
        #if os(iOS)
        for touch in touches {
            let location = touch.locationInNode(scene)
            if scene.playButton.containsPoint(location) {
                scene.playButton.texture = PlayButton.press()
                restartGame()
            }
            
            if scene.gameCenterButton.containsPoint(location) {
                scene.showLeaderboard()
            } else if scene.rateButton.containsPoint(location) {
                scene.rateApp()
            }
        }
        #elseif os(tvOS)
        restartGame()
        #endif
    }
    
    // MARK: - Restart
    
    func restartGame() {
        let newScene = GameScene(size: scene.size)
        newScene.viewController = scene.viewController
        let transition = SKTransition.fadeWithColor(.blackColor(), duration: 0.02)
        scene.view?.presentScene(newScene, transition: transition)
    }
}