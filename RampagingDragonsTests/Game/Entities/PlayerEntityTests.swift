//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import XCTest
import SpriteKit
@testable import RampagingDragons

class PlayerEntityTests: XCTestCase {
    
    var scene = TestUtil.getGameScene()
    let player = PlayerEntity()
    
    override func setUp() {
        super.setUp()
        scene.addChild(player.spriteComponent.node)
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
    
    func testMovement() {
        player.maxLeft = -1000
        player.maxRight = 1000
        
        player.moveLeft()
        XCTAssert(player.movement == .Left, "Player should be moving left")
        
        player.moveRight()
        XCTAssert(player.movement == .Right, "Player should be moving right")
        
        player.die()
        XCTAssert(player.movement == .Neutral, "Player shouldn't be moving")
        
    }
}