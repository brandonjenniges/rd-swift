//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import XCTest
import SpriteKit
@testable import RampagingDragons

class PlatformTests: XCTestCase {
    
    var scene = TestUtil.getMenuScene()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreate() {
        let platform = Platform.create(scene)
        XCTAssertNotNil(platform, "Unable to create platform")
    }
    
}