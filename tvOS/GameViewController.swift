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
        
        if let scene = SKScene(fileNamed: "MenuScene") as? MenuScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            scene.viewController = self
            skView.presentScene(scene)
        } else {
            print("Couldn't find scene")
        }
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
                        scene?.view?.paused = true
                        if let scene = SKScene(fileNamed: "PauseScene") {
                            // Configure the view.
                            let skView = self.view as! SKView
                            skView.presentScene(scene)
                        }
                    } else {
                        
                    }
                    
                }
            }
        }
    }
}
