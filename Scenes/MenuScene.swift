//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit
import GameKit

class MenuScene: SKScene {
    
    var viewController:GameViewController!
    
    override func didMoveToView(view: SKView) {
        
        #if os(tvOS)
        viewController.controllerUserInteractionEnabled = true
        #endif
        
        createBackground()
        createLogo()
        addPlayButton()
        setupDragons(view)
    }
    
    // MARK: - Touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let scene = GameScene(size: self.view!.frame.size)
        scene.scaleMode = .AspectFill
        scene.viewController = viewController
        self.view!.presentScene(scene, transition: SKTransition.crossFadeWithDuration(1.0))
    }
    
    // MARK: - Elements
    
    func createBackground() {
        Background.create(self)
    }
    
    func createLogo() {
        Logo.create(self)
    }
    
    func addPlayButton() {
        let playButton = SKSpriteNode(texture: TextureAtlasManager.introAtlas.textureNamed("play"))
        if let logoNode = Logo.getNode(self) {
            playButton.position = CGPointMake(logoNode.position.x, logoNode.position.y / 2)
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
