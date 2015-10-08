//
//  GameViewController.swift
//  tvOS
//
//  Created by Brandon Jenniges on 9/26/15.
//  Copyright (c) 2015 Brandon Jenniges. All rights reserved.
//

import UIKit
import SpriteKit
import GameController

class GameViewController: GCEventViewController {

    var keystore: NSUbiquitousKeyValueStore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
            
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
            
        let scene = MenuScene(size: skView.frame.size)
        scene.viewController = self
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
          for press in presses {
            if press.type == .Menu {
                let scene = (self.view as! SKView).scene
                if scene!.isKindOfClass(MenuScene)  {
                    super.pressesEnded(presses, withEvent: event)
                } else {
                
                    if scene!.isKindOfClass(GameScene) {
                        //scene?.view?.paused = true
                        //Get some type of content node and pause only that, leaving pause scene un paused
                        if let overlayScene = SKScene(fileNamed: "PauseScene") {
                            let contentTemplateNode = overlayScene.childNodeWithName("Overlay") as! SKSpriteNode
                            
                            // Create a background node with the same color as the template.
                            let backgroundNode = SKSpriteNode(color: contentTemplateNode.color, size: contentTemplateNode.size)
                            backgroundNode.zPosition = 10
                            backgroundNode.position = CGPointMake(backgroundNode.frame.size.width / 2, backgroundNode.frame.size.height / 2)
                            
                            // Copy the template node into the background node.
                            let contentNode = contentTemplateNode.copy() as! SKSpriteNode
                            backgroundNode.addChild(contentNode)
                            
                            // Set the content node to a clear color to allow the background node to be seen through it.
                            contentNode.color = .clearColor()
                            contentNode.position = .zero
                            
                            // Store the current size of the content to allow it to be scaled correctly.
                            let nativeContentSize = contentNode.size
                            scene?.addChild(backgroundNode)
                            
                        }
                    } else {
                        
                    }
                    
                }
            }
        }
    }
}
