//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import XCTest
import SpriteKit
@testable import RampagingDragons

class LogoTests: XCTestCase {
    
    var scene = TestUtil.getMenuScene()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreate() {
        let logo = Logo.create(scene)
        XCTAssertNotNil(logo, "Unable to create logo")
    }
    
    func testGetNode() {
        let logo = Logo.create(scene)
        scene.addChild(logo)
        XCTAssertNotNil(Logo.getNode(scene), "Unable to find logo node")
    }
}