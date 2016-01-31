//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit
import GameKit

class MenuScene: SKScene {
    
    var viewController:GameViewController!
    
    var background: SKSpriteNode!
    
    var logo: SKSpriteNode!
    var platform: SKSpriteNode!
    var player: PlayerEntity!
    
    var playButton: SKSpriteNode!
    
    var gameCenterButton: SKSpriteNode!
    var rateButton: SKSpriteNode!
    var creditsLogo: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        setupBackground()
        setupLogo()
        setupCredits()
        setupGround()
        setupPlayButton()
        setupRateButton()
        setupGameCenterButton()
    }
    
    // MARK: - Setup Methods
    
    func setupBackground() {
        background = Background.create(self)
        addChild(background)
    }
    
    func setupLogo() {
        logo = Logo.create(self)
        addChild(logo)
        logo.runAction(Logo.pulseAction())
    }
    
    func setupCredits() {
        creditsLogo = CreditsLogo.create(self)
        addChild(creditsLogo)
    }
    
    func setupPlayButton() {
        playButton = PlayButton.create(self)
        playButton.position = CGPointMake(size.width / 2, (logo.position.y + player.spriteComponent.node.position.y) / 2)
        addChild(playButton)
    }
    
    func setupGround() {
        
        // Ground
        platform = Platform.create(self)
        addChild(platform)
        
        // Mountain
        let mountain = Mountain.create(self, platform: platform)
        addChild(mountain)
        
        // Player
        
        player = PlayerEntity()
        addChild(player.spriteComponent.node)
        player.spriteComponent.node.position = CGPointMake(platform.position.x, platform.position.y + (platform.size.height / 2) + (player.spriteComponent.node.size.height / 2) - 5)
    }
    
    func setupRateButton() {
        rateButton = Button.create(self)
        rateButton.position = CGPointMake(rateButton.size.width / 1.5, (platform.position.y + creditsLogo.position.y) / 2)
        addChild(rateButton)
        
        let rateIcon = RateButton.create(self)
        rateIcon.position = .zero
        rateButton.addChild(rateIcon)
    }
    
    func setupGameCenterButton() {
        gameCenterButton = Button.create(self)
        gameCenterButton.position = CGPointMake(rateButton.position.x + gameCenterButton.size.width * 1.25, rateButton.position.y)
        addChild(gameCenterButton)
        
        let gameCenterIcon = GameCenterButton.create(self)
        gameCenterIcon.position = .zero
        gameCenterButton.addChild(gameCenterIcon)
    }
    
    // MARK: - Touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            if playButton.containsPoint(location) {
                playButton.texture = PlayButton.press()
            } else if gameCenterButton.containsPoint(location) {
                gameCenterButton.texture = Button.press()
            } else if rateButton.containsPoint(location) {
                rateButton.texture = Button.press()
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        playButton.texture = PlayButton.pressEnded()
        gameCenterButton.texture = Button.pressEnded()
        rateButton.texture = Button.pressEnded()
        
        for touch in touches {
            let location = touch.locationInNode(self)
            if playButton.containsPoint(location) {
                handlePlayButtonPress()
            } else if gameCenterButton.containsPoint(location) {
                handleGameCenterButtonPress()
            } else if rateButton.containsPoint(location) {
                handleRateButtonPress()
            }
        }
    }
    
    func handlePlayButtonPress() {
        guard let view = view else { return }
        let scene = GameScene(size: size, viewController: viewController, background: background)
        view.presentScene(scene, transition: SKTransition.fadeWithDuration(1.0))
    }
    
    func handleGameCenterButtonPress() {
        showLeaderboard(viewController)
    }
    
    func handleRateButtonPress() {
        rateApp()
    }
}
