//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import XCTest
import SpriteKit
@testable import RampagingDragons

class ScoreboardTests: XCTestCase {
    
    var scene = TestUtil.getGameScene()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreate() {
        let scoreboard = ScoreBoard(score: 100)
        XCTAssertNotNil(scoreboard, "Unable to create scoreboard")
    }
    
}