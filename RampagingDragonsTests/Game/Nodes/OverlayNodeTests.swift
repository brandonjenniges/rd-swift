//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import XCTest
import SpriteKit
@testable import RampagingDragons

class OverlayNodeTests: XCTestCase {
    
    var scene = TestUtil.getGameScene()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreate() {
        let overlayNode = OverlayNode.create(scene, score: 100)
        XCTAssertNotNil(overlayNode, "Unable to create overlay node")
    }
    
}