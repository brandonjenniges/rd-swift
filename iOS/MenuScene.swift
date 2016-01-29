//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit
import GameKit

class MenuScene: SKScene {
    
    var viewController:GameViewController!
    var playButton: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        setupBackground()
        setupLogo()
        setupCredits()
        setupPlayButton()
        setupGround()
    }
    
    // MARK: - Setup Methods
    
    func setupBackground() {
        let background = Background.create(self)!
        addChild(background)
    }
    
    func setupLogo() {
        let logo = Logo.create(self)!
        addChild(logo)
        logo.runAction(Logo.pulseAction())
    }
    
    func setupCredits() {
        let creditsLogo = CreditsLogo.create(self)!
        addChild(creditsLogo)
    }
    
    func setupPlayButton() {
        playButton = PlayButton.create(self)
        playButton.position = CGPointMake(size.width / 2, size.height / 2)
        addChild(playButton)
    }
    
    func setupGround() {
        
        // Ground
        let platform = Platform.create(self)!
        addChild(platform)
        
        // Mountain
        let mountain = Mountain.create(self, platform: platform)!
        addChild(mountain)
        
        // Player
        
        let player = PlayerEntity()
        addChild(player.spriteComponent.node)
        player.spriteComponent.node.position = CGPointMake(platform.position.x, platform.position.y + (platform.size.height / 2) + (player.spriteComponent.node.size.height / 2) - 5)
    }
    
    // MARK: - Touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            if playButton.containsPoint(location) {
                playButton.texture = PlayButton.press()
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        playButton.texture = PlayButton.pressEnded()
        
        for touch in touches {
            let location = touch.locationInNode(self)
            if playButton.containsPoint(location) {
                handlePlayButtonPress()
            }
        }
    }
    
    func handlePlayButtonPress() {
        guard let view = view else { return }
        let scene = GameScene(size: size)
        scene.viewController = viewController
        view.presentScene(scene, transition: SKTransition.fadeWithDuration(1.0))
    }
}
