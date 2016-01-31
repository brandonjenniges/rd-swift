//
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
        
        #if DEBUG
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsPhysics = true
        #endif
        
        let scene = MenuScene(size: skView.frame.size)
        scene.viewController = self
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
                }
            }
        }
    }
}
