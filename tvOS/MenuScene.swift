//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit
import GameKit

class MenuScene: SKScene {
    
    var viewController:GameViewController!
    var playButton: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        
        viewController.controllerUserInteractionEnabled = true
        
        setupBackground()
        setupLogo()
        setupCredits()
        setupPlayButton()
        setupDragons(view)
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
        
        if let logoNode = Logo.getNode(self) {
            playButton.position = CGPointMake(logoNode.position.x, logoNode.position.y / 2)
            addChild(playButton)
        }
    }
    
    func setupDragons(view: SKView) {
        
        let dragonArray = DragonEntity.getDragonArray()
        
        var index = 0
        let gapSize = view.frame.width / CGFloat(dragonArray.count)
        
        let leftXPos = gapSize * CGFloat(0) + gapSize / 2
        let rightXPos = gapSize * CGFloat(3) + gapSize / 2
        let topYPos = view.frame.size.height * 0.75
        let bottomYPos = view.frame.size.height * 0.25
        
        let yPositions = [topYPos, topYPos, bottomYPos, bottomYPos]
        let xPositions = [leftXPos, rightXPos, leftXPos, rightXPos]
        for dragon in dragonArray {
            let dragonNode = dragon.spriteComponent.node
            dragon.setUpDragonAnimations()
            dragonNode.position = CGPointMake(xPositions[index], yPositions[index])
            addChild(dragonNode)
            index++
        }
    }
    
    // MARK: - Touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        playButton.texture = PlayButton.press()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        playButton.texture = PlayButton.pressEnded()
        handlePlayButtonPress()
    }
    
    func handlePlayButtonPress() {
        
        guard let view = view else { return }
        let scene = GameScene(size: view.frame.size)
        scene.viewController = viewController
        view.presentScene(scene, transition: SKTransition.fadeWithDuration(1.0))
    }
}
