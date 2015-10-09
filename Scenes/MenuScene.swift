//
//  MenuScene.swift
//  Launchy Demo
//
//  Created by Brandon Jenniges on 9/26/15.
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    let introAtlas = SKTextureAtlas(named: "Intro")
    let playerAtlas = SKTextureAtlas(named: "Player")
    
    var viewController:GameViewController!
    
    var dragon0:Dragon!
    var dragon1:Dragon!
    var dragon2:Dragon!
    var dragon3:Dragon!
    var dragonArray:[Dragon]!
    
    var player:Player!
    
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
        let background = SKSpriteNode(texture:introAtlas.textureNamed("background"))
        background.position = CGPointMake(view!.frame.width / 2, view!.frame.height / 2)
        addChild(background)
    }
    
    func addLogo() {
        let logo = SKSpriteNode(texture:introAtlas.textureNamed("logo"))
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
        let platform = SKSpriteNode(texture: playerAtlas.textureNamed("ground"))
        platform.position = CGPointMake(view!.frame.width / 2, view!.frame.height / 4)
        print(platform.texture?.size())
        platform.zPosition = 1
        addChild(platform)
        
    }
    
    func setupPlayer() {
        //player = childNodeWithName("player") as! Player
        player = Player()
        player.runPlayerLookingAnimation()
    }
    
    func setupDragons() {
        //dragon0 = childNodeWithName("dragon0") as! Dragon
        //dragon1 = childNodeWithName("dragon1") as! Dragon
        //dragon2 = childNodeWithName("dragon2") as! Dragon
        //dragon3 = childNodeWithName("dragon3") as! Dragon
        
        dragon0 = Dragon(imageName: "dragon0_0")
        dragon1 = Dragon(imageName: "dragon1_0")
        dragon2 = Dragon(imageName: "dragon2_0")
        dragon3 = Dragon(imageName: "dragon3_0")
        
        #if os(tvOS)
            dragonArray = [dragon0, dragon1, dragon2, dragon3]
            dragon2.xScale = -1
            dragon3.xScale = -1
        #else
            dragonArray = [dragon0, dragon1]
            dragon1.xScale = -1
        #endif
        
        
        var index = 0
        let gapSize = view!.frame.width / CGFloat(dragonArray.count)
        let yPos = view!.frame.size.height * 0.75
        
        for dragon in dragonArray {
            print(dragon.texture!.size())
            dragon.setUpDragonAnimations(index)
           // print(xPos)
            dragon.position = CGPointMake(gapSize * CGFloat(index) + gapSize / 2, yPos)
            addChild(dragon)
            index++
        }
    }
}
