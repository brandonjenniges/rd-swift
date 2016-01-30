//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit
import GameKit

class MenuScene: SKScene {
    
    var viewController:GameViewController!
    
    var creditsLogo: SKSpriteNode!
    
    var playButton: SKSpriteNode!
    var gameCenterButton: SKSpriteNode!
    var rateButton: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        setupBackground()
        setupLogo()
        setupCredits()
        setupPlayButton()
        setupGround()
        setupGameCenterButton()
        setupRateButton()
    }
    
    // MARK: - Setup Methods
    
    func setupBackground() {
        let background = Background.create(self)
        addChild(background)
    }
    
    func setupLogo() {
        let logo = Logo.create(self)
        addChild(logo)
        logo.runAction(Logo.pulseAction())
    }
    
    func setupCredits() {
        creditsLogo = CreditsLogo.create(self)
        addChild(creditsLogo)
    }
    
    func setupPlayButton() {
        playButton = PlayButton.create(self)
        playButton.position = CGPointMake(size.width / 2, size.height / 2)
        addChild(playButton)
    }
    
    func setupGround() {
        
        // Ground
        let platform = Platform.create(self)
        addChild(platform)
        
        // Mountain
        let mountain = Mountain.create(self, platform: platform)
        addChild(mountain)
        
        // Player
        
        let player = PlayerEntity()
        addChild(player.spriteComponent.node)
        player.spriteComponent.node.position = CGPointMake(platform.position.x, platform.position.y + (platform.size.height / 2) + (player.spriteComponent.node.size.height / 2) - 5)
    }
    
    func setupGameCenterButton() {
        gameCenterButton = Button.create(self)
        gameCenterButton.position = CGPointMake(gameCenterButton.size.width, creditsLogo.position.y + gameCenterButton.size.height * 2)
        addChild(gameCenterButton)
        
        let gameCenterIcon = GameCenterButton.create(self)
        gameCenterIcon.position = .zero
        gameCenterButton.addChild(gameCenterIcon)
    }
    
    func setupRateButton() {
        rateButton = Button.create(self)
        rateButton.position = CGPointMake(gameCenterButton.position.x + gameCenterButton.size.width * 1.5, creditsLogo.position.y + rateButton.size.height * 2)
        addChild(rateButton)
        
        let rateIcon = RateButton.create(self)
        rateIcon.position = .zero
        rateButton.addChild(rateIcon)
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
        let scene = GameScene(size: size)
        scene.viewController = viewController
        view.presentScene(scene, transition: SKTransition.fadeWithDuration(1.0))
    }
    
    func handleGameCenterButtonPress() {
        
    }
    
    func handleRateButtonPress() {
        
    }
}
