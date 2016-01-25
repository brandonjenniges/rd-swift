//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import XCTest
import SpriteKit
@testable import RampagingDragons

class CreditsLogoTests: XCTestCase {
    
    var scene = TestUtil.getMenuScene()
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreate() {
        let logo = CreditsLogo.create(scene)
        XCTAssert(logo != nil, "Unable to create credits logo")
    }
    
}