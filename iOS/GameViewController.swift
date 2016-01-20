//
//  Copyright (c) 2015 Brandon Jenniges. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        let scene = MenuScene(size: skView.frame.size)
        scene.viewController = self
        
        //startGameCenter()
        
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
