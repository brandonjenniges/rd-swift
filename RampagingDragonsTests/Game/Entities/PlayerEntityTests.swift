//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import XCTest
import SpriteKit
@testable import RampagingDragons

class PlayerEntityTests: XCTestCase {
    
    let player = PlayerEntity()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreate() {
        XCTAssertNotNil(player, "Unable to create player")
    }
    
    func testRunningCompleteAction() {
        let action = player.getRunningCompletionAction()
        XCTAssertNotNil(action, "Unable to create running completion action")
    }
}