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
        print("moved")
      //  setupPlayer()
        viewController.controllerUserInteractionEnabled = true
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
        player = childNodeWithName("player") as! Player
        player.runPlayerLookingAnimation()
    }
    
    func setupDragons() {
        dragon0 = childNodeWithName("dragon0") as! Dragon
        dragon1 = childNodeWithName("dragon1") as! Dragon
        dragon2 = childNodeWithName("dragon2") as! Dragon
        dragon3 = childNodeWithName("dragon3") as! Dragon
        dragonArray = [dragon0, dragon1, dragon2, dragon3]
        
        
        var index = 0
        for dragon in dragonArray {
            dragon.setUpDragonAnimations(index)
            index++
        }
    }
}
