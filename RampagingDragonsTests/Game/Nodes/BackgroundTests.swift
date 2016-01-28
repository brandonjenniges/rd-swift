//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import XCTest
import SpriteKit
@testable import RampagingDragons

class BackgroundTests: XCTestCase {
    
    var scene = TestUtil.getMenuScene()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreate() {
        let background = Background.create(scene)
        XCTAssertNotNil(background, "Unable to create background")
    }
    
}
