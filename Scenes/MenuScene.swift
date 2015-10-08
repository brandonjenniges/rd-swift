//
//  MenuScene.swift
//  Launchy Demo
//
//  Created by Brandon Jenniges on 9/26/15.
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
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
        #else
            dragonArray = [dragon0, dragon1]
        #endif
        
        
        var index = 0
        let gapSize = view!.frame.width / 4
        let yPos = view!.frame.size.height * 0.8
        
        for dragon in dragonArray {
            dragon.setUpDragonAnimations(index)
            let xPos = gapSize * CGFloat(index + 1) - dragon.texture!.size().width
            print(xPos)
            dragon.position = CGPointMake((gapSize / 2) * CGFloat(index + 1) + (dragon.texture!.size().width / 2), yPos - dragon.texture!.size().height / 2)
            addChild(dragon)
            index++
        }
    }
}
