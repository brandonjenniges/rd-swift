//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import XCTest
import SpriteKit
@testable import RampagingDragons

class PulseAnimationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testActions() {
        let pulseAction0 = PulseAnimation.pulseAction(50)
        XCTAssertNotNil(pulseAction0, "Unable to create pulse action")
        let pulseAction1 = PulseAnimation.pulseAction(50, duration: 2)
        XCTAssertNotNil(pulseAction1, "Unable to create pulse action")
        let pulseAction2 = PulseAnimation.pulseAction(0.5, scale: 1.0)
        XCTAssertNotNil(pulseAction2, "Unable to create pulse action")
    }
}
