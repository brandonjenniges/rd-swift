//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import XCTest
import SpriteKit
@testable import RampagingDragons

class MountainTests: XCTestCase {
    
    var scene = TestUtil.getMenuScene()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreate() {
        let mountain = Mountain.create(scene, platform: Platform.create(scene)!)
        XCTAssertNotNil(mountain, "Unable to create mountain logo")
    }
    
}