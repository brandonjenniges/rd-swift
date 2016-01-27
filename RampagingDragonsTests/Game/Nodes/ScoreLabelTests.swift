//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import XCTest
import SpriteKit
@testable import RampagingDragons

class ScoreLabelTests: XCTestCase {
    
    var scene = TestUtil.getGameScene()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreate() {
        let scoreLabel = ScoreLabel.create(scene)
        XCTAssertNotNil(scoreLabel, "Unable to create score label")
    }
    
}