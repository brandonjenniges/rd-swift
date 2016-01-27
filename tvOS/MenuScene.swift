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
        
        createBackground()
        createLogo()
        createCreditsLogo()
        addPlayButton()
        setupDragons(view)
    }
    
    // MARK: - Touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        playButton.alpha = 0.5
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        playButton.alpha = 1.0
        handlePlayButtonPress()
    }
    
    func handlePlayButtonPress() {
        
        guard let view = view else { return }
        let scene = GameScene(size: view.frame.size)
        scene.viewController = viewController
        view.presentScene(scene, transition: SKTransition.fadeWithDuration(1.0))
    }
    
    // MARK: - Elements
    
    func createBackground() {
        Background.create(self)
    }
    
    func createLogo() {
        Logo.create(self)
    }
    
    func createCreditsLogo() {
        CreditsLogo.create(self)
    }
    
    func addPlayButton() {
        playButton = SKSpriteNode(texture: TextureAtlasManager.introAtlas.textureNamed("play"))
        if let logoNode = Logo.getNode(self) {
            playButton.position = CGPointMake(logoNode.position.x, logoNode.position.y / 2)
            playButton.zPosition = 2
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
}
