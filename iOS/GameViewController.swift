//
//  Copyright (c) 2015 Brandon Jenniges. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let skView = self.view as! SKView
        
        #if DEBUG
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsPhysics = true
        #endif
        
        skView.multipleTouchEnabled = true
        
        let aspectRatio = skView.bounds.size.height / skView.bounds.size.width
        let scene = MenuScene(size: CGSize(width: 320, height: 320 * aspectRatio), viewController: self)
        
        scene.scaleMode = .AspectFill
        
        startGameCenter()
        
        skView.presentScene(scene)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func startGameCenter() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showAuthenticationViewController", name: PresentAuthenticationViewController, object: nil)
        GameKitHelper.sharedGameKitHelper.authenticateLocalPlayer()
    }
    
    func showAuthenticationViewController() {
        let gameKitHelper = GameKitHelper.sharedGameKitHelper
        if let authenitcationViewController = gameKitHelper.authenitcationViewController {
            self.presentViewController(authenitcationViewController, animated: true, completion: nil)
        }
    }
}
