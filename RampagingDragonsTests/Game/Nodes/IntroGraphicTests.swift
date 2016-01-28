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
    
}