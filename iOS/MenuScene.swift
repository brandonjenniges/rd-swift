//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit
import GameKit

class MenuScene: SKScene {
    
    var viewController:GameViewController!
    var playButton: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        createBackground()
        createLogo()
        createCreditsLogo()
        addPlayButton()
        
        let platform = Platform.create(self)
        let player = PlayerEntity()
        addChild(player.spriteComponent.node)
        player.spriteComponent.node.position = CGPointMake(platform!.position.x, platform!.position.y + (platform!.size.height / 2) + (player.spriteComponent.node.size.height / 2) - 5)
        //setupDragons(view)
    }
    
    // MARK: - Touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
            for touch in touches {
                let location = touch.locationInNode(self)
                if playButton.containsPoint(location) {
                    playButton.alpha = 0.5
                }
            }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        playButton.alpha = 1.0
        
        for touch in touches {
            let location = touch.locationInNode(self)
            if playButton.containsPoint(location) {
                handlePlayButtonPress()
            }
        }
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
            playButton.position = CGPointMake(logoNode.position.x, view!.frame.size.height / 2)
            playButton.zPosition = 2
            addChild(playButton)
        }
    }
    
    func setupDragons(view: SKView) {
        
        let dragonArray = Dragon.getDragonArray()
        
        var index = 0
        let gapSize = view.frame.width / CGFloat(dragonArray.count)
        
        let leftXPos = gapSize * CGFloat(0) + gapSize / 2
        let rightXPos = gapSize * CGFloat(3) + gapSize / 2
        let topYPos = view.frame.size.height * 0.75
        let bottomYPos = view.frame.size.height * 0.25
        
        let yPositions = [topYPos, topYPos, bottomYPos, bottomYPos]
        let xPositions = [leftXPos, rightXPos, leftXPos, rightXPos]
        for dragon in dragonArray {
            dragon.setUpDragonAnimations()
            dragon.position = CGPointMake(xPositions[index], yPositions[index])
            addChild(dragon)
            index++
        }
    }
}
