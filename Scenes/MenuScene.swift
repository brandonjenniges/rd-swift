//
//  MenuScene.swift
//  Launchy Demo
//
//  Created by Brandon Jenniges on 9/26/15.
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit
import GameKit

class MenuScene: SKScene {
    
    var viewController:GameViewController!
    
    var dragonArray:[Dragon]!
    
    override func didMoveToView(view: SKView) {
        #if os(tvOS)
            viewController.controllerUserInteractionEnabled = true
        #endif
        addBackground()
        addLogo()
        addPlatform()
        setupDragons()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            scene.viewController = viewController
            self.view!.presentScene(scene, transition: SKTransition.crossFadeWithDuration(1.0))
        } else {
            print("Couldn't find scene")
        }
    }
    
    //MARK: Elements
    func addBackground() {
        let background = SKSpriteNode(texture:TextureAtlasManager.introAtlas.textureNamed("background"))
        background.position = CGPointMake(view!.frame.width / 2, view!.frame.height / 2)
        addChild(background)
    }
    
    func addLogo() {
        let logo = SKSpriteNode(texture:TextureAtlasManager.introAtlas.textureNamed("logo"))
        logo.position = CGPointMake(view!.frame.width / 2, view!.frame.height / 2)
        logo.zPosition = 2
        addChild(logo)
        
        let growAction = SKAction.scaleTo(1.05, duration: 1)
        growAction.timingMode = .EaseInEaseOut
        let shrinkAction = SKAction.scaleTo(0.95, duration: 1)
        shrinkAction.timingMode = .EaseInEaseOut
        let sequence = SKAction.sequence([growAction, shrinkAction])
        let repeatAction = SKAction.repeatActionForever(sequence)
        
        logo.runAction(repeatAction)
    }
    
    func addPlatform() {
        let platform = SKSpriteNode(texture: TextureAtlasManager.playerAtlas.textureNamed("ground"))
        platform.position = CGPointMake(view!.frame.width / 2, view!.frame.height / 4)
        print(platform.texture?.size())
        platform.zPosition = 1
        addChild(platform)
        
    }
    
    func setupPlayer() {
        let player = Player()
        //TODO: Position player
    }
    
    func setupDragons() {
        
        dragonArray = Dragon.getDragonArray()
        
        
        var index = 0
        let gapSize = view!.frame.width / CGFloat(dragonArray.count)
        let yPos = view!.frame.size.height * 0.75
        
        for dragon in dragonArray {
            print(dragon.texture!.size())
            dragon.setUpDragonAnimations()
            dragon.position = CGPointMake(gapSize * CGFloat(index) + gapSize / 2, yPos)
            addChild(dragon)
            index++
        }
    }
}
