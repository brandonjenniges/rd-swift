//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import XCTest
import SpriteKit
@testable import RampagingDragons

class TestUtil {
    
    // MARK: - Test Helpers
    
    static func getMenuScene() -> MenuScene {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! GameViewController
        let skView = viewController.view as! SKView
        let scene = MenuScene(size: skView.frame.size)
        skView.presentScene(scene)
        return scene
    }
    
    static func getGameScene() -> GameScene {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! GameViewController
        let skView = viewController.view as! SKView
        let scene = GameScene(size: skView.frame.size)
        skView.presentScene(scene)
        return scene
    }
    
}
