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
    let logoNodeName = "logo"
    
    override func didMoveToView(view: SKView) {
        #if os(tvOS)
            viewController.controllerUserInteractionEnabled = true
        #endif
        addBackground()
        addLogo()
        addPlayButton()
        setupDragons()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let scene = GameScene(size: self.view!.frame.size)
        scene.scaleMode = .AspectFill
        scene.viewController = viewController
        self.view!.presentScene(scene, transition: SKTransition.crossFadeWithDuration(1.0))
    }
    
    //MARK: Elements
    func addBackground() {
        let background = SKSpriteNode(color: UIColor(red: 126/255.0, green: 200/255.0, blue: 219/255.0, alpha: 1.0), size: view!.frame.size)
        
        
        let cloud = SKSpriteNode(texture:TextureAtlasManager.introAtlas.textureNamed("cloud"))
        let numberOfClouds = Int(ceil(view!.frame.size.width / cloud.size.width))
        
        let clouds = SKSpriteNode()
        clouds.anchorPoint = CGPointMake(0.5, 0.5)
        clouds.size = CGSizeMake(CGFloat(numberOfClouds) * cloud.size.width, cloud.size.height)
        for index in 1...numberOfClouds {
            let c = cloud.copy() as! SKSpriteNode
            c.anchorPoint = CGPointMake(0, 0.5)
            c.position = CGPointMake((CGFloat(index - 1) * c.frame.size.width) - clouds.size.width / 2, 0)
            clouds.addChild(c)
        }
        clouds.position = CGPointMake(0, 0)
        background.addChild(clouds)
        
        let bottomClouds = SKSpriteNode(color: UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.4), size: CGSizeMake(view!.frame.size.width, view!.frame.size.height / 2 - clouds.frame.origin.y))
        bottomClouds.position = CGPointMake(0, -(clouds.frame.size.height / 2) - bottomClouds.frame.size.height / 2)
        background.addChild(bottomClouds)
        
        background.position = CGPointMake(view!.frame.width / 2, view!.frame.height / 2)
        addChild(background)
    }
    
    func addLogo() {
        let logo = SKSpriteNode(texture:TextureAtlasManager.introAtlas.textureNamed("logo"))
        logo.name = logoNodeName
        logo.position = CGPointMake(view!.frame.width / 2, view!.frame.height * 0.6)
        logo.zPosition = 2
        addChild(logo)
        
        let pulseAction =  PulseAnimation.pulseAction(0.05)
        logo.runAction(pulseAction)
    }
    
    func addPlayButton() {
        let playButton = SKSpriteNode(texture: TextureAtlasManager.introAtlas.textureNamed("play"))
        let logoNode = childNodeWithName(logoNodeName)
        playButton.position = CGPointMake(logoNode!.position.x, logoNode!.position.y / 2)
        playButton.zPosition = 2
        addChild(playButton)
    }
    
    func setupDragons() {
        
        let dragonArray = Dragon.getDragonArray()
        
        var index = 0
        let gapSize = view!.frame.width / CGFloat(dragonArray.count)
        
        let leftXPos = gapSize * CGFloat(0) + gapSize / 2
        let rightXPos = gapSize * CGFloat(3) + gapSize / 2
        let topYPos = view!.frame.size.height * 0.75
        let bottomYPos = view!.frame.size.height * 0.25
        
        let yPositions = [topYPos, topYPos, bottomYPos, bottomYPos]
        let xPositions = [leftXPos, rightXPos, leftXPos, rightXPos]
        for dragon in dragonArray {
            //print(dragon.texture!.size())
            dragon.setUpDragonAnimations()
            dragon.position = CGPointMake(xPositions[index], yPositions[index])
            addChild(dragon)
            index++
        }
    }
}
