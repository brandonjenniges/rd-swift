//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverState: GKState {
    
    unowned let scene: GameScene
    var allowInteraction = false
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        
        #if os(iOS)
        removeControlPad()
        #endif
        
        setupGameOver()
        removeScoreLabel()
        
        scene.player.die()
        #if os(iOS)
        scene.reportScoreToGameCenter()
        #endif
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is IntroState.Type
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        scene.updateClouds()
    }
    
    // MARK: - State Touches
    
    override func handleTouches(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Scene is animating, don't allow touches
        if !self.allowInteraction { return }
        
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
        let fadeOutAction = SKAction.fadeAlphaTo(0, duration: scene.animationDuration)
        fadeOutAction.timingMode = .EaseInEaseOut
        scene.scoreLabel.runAction(fadeOutAction)
    }
    
    // MARK: - Node
    
    
    func setupGameOver() {
        
        //Gameover label
        let gameover = SKSpriteNode(texture: TextureAtlasManager.gameOverAtlas.textureNamed("gameover"))
        gameover.zPosition = GameLayer.Layer.GameOver.rawValue
        gameover.position = CGPointMake(scene.size.width / 2, scene.size.height * 0.80)
        gameover.setScale(0)
        gameover.alpha = 0
        scene.worldNode.addChild(gameover)
        
        //Game over animation
        let gameoverAnimationGroup = SKAction.group([SKAction.fadeInWithDuration(0.3), SKAction.scaleTo(1.0, duration: scene.animationDuration)])
        gameoverAnimationGroup.timingMode = .EaseInEaseOut
        gameover.runAction(gameoverAnimationGroup)
        
        //Play button
        scene.playButton = PlayButton.create(scene)
        scene.playButton.position = CGPointMake(scene.size.width / 2, scene.size.height / 4)
        scene.playButton.alpha = 0
        scene.worldNode.addChild(scene.playButton)
        scene.playButton.runAction(scene.buttonFadeInAnimation(3))
        
        //Scorecard
        let scorecard = ScoreBoard(score: scene.score)
        scorecard.position = CGPointMake(scene.size.width / 2, -scene.size.height + -scorecard.frame.size.height)
        scene.worldNode.addChild(scorecard)
        let moveAction = SKAction.moveToY((gameover.position.y + scene.playButton.position.y) / 2, duration: 0.4)
        moveAction.timingMode = .EaseInEaseOut
        scorecard.runAction(moveAction)
        
        
        #if os(iOS)
            setupRateButton()
            setupGameCenterButton()
        #endif
        
        pauseForScenePress()
    }
    
    func setupRateButton() {
        scene.rateButton = Button.create(scene)
        scene.rateButton.position = CGPointMake(scene.rateButton.size.width / 1.5, scene.platform.position.y / 2)
        scene.rateButton.alpha = 0
        scene.addChild(scene.rateButton)
        
        let rateIcon = RateButton.create(scene)
        rateIcon.position = .zero
        scene.rateButton.addChild(rateIcon)
        scene.rateButton.runAction(scene.buttonFadeInAnimation(3))
    }
    
    func setupGameCenterButton() {
        scene.gameCenterButton = Button.create(scene)
        scene.gameCenterButton.position = CGPointMake(scene.rateButton.position.x + scene.gameCenterButton.size.width * 1.25, scene.rateButton.position.y)
        scene.gameCenterButton.alpha = 0
        scene.addChild(scene.gameCenterButton)
        
        let gameCenterIcon = GameCenterButton.create(scene)
        gameCenterIcon.position = .zero
        scene.gameCenterButton.addChild(gameCenterIcon)
        scene.gameCenterButton.runAction(scene.buttonFadeInAnimation(3))
    }
    
    func pauseForScenePress() {
        let delayAction = SKAction.waitForDuration(3 * scene.animationDuration)
        let block = SKAction.runBlock { () -> Void in
            self.allowInteraction = true
        }
        scene.runAction(SKAction.sequence([delayAction, block]))
    }
    
    // MARK: - Restart
    
    func restartGame() {
        let newScene = GameScene(size: scene.size, viewController: scene.viewController, background: scene.background)
        scene.view!.presentScene(newScene, transition: SKTransition.fadeWithDuration(1.0))
    }
}