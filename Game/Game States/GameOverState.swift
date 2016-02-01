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
        removeControlPad()
        #endif
        
        scene.setupGameOver()
        removeScoreLabel()
        
        scene.player.die()
        scene.reportScoreToGameCenter()
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is IntroState.Type
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        scene.updateClouds()
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
    
    #if os(iOS)
    func removeControlPad() {
        scene.control.animateOut(CGPointMake(-scene.control.left.size.width, -scene.control.left.size.height), node: scene.control.left)
        scene.control.animateOut(CGPointMake(scene.size.width + scene.control.right.size.width, -scene.control.right.size.height), node: scene.control.right)
    }
    
    #endif
    
    func removeScoreLabel() {
        let fadeOutAction = SKAction.fadeAlphaTo(0, duration: 0.3)
        fadeOutAction.timingMode = .EaseInEaseOut
        scene.scoreLabel.runAction(fadeOutAction)
    }
    
    // MARK: - Restart
    
    func restartGame() {
        let newScene = GameScene(size: scene.size, viewController: scene.viewController, background: scene.background)
        scene.view!.presentScene(newScene, transition: SKTransition.fadeWithDuration(1.0))
    }
}