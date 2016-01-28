//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import XCTest
import SpriteKit
@testable import RampagingDragons

class IntroGraphicTests: XCTestCase {
    
    var scene = TestUtil.getGameScene()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreate() {
        let introGraphic = IntroGraphic.create(scene)
        XCTAssertNotNil(introGraphic, "Unable to create intro graphic")
    }
    
    func testRemove() {
        let introGraphic = IntroGraphic.create(scene)!
        scene.addChild(introGraphic)
        
        IntroGraphic.remove(scene)
        
        // Delay because IntroGraphic has an animation for removing from scene 
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            XCTAssertNil(self.scene.childNodeWithName(IntroGraphic.nodeName), "Intro graphic still in scene")
        }
        
    }
    
}