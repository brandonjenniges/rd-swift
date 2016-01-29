//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import XCTest
import SpriteKit
@testable import RampagingDragons

class FireballEntityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreate() {
    }
    
    func testGaps() {
        let fireball = FireballEntity()
        
        FireballEntity.setupGaps(100, worldWidth: 1000)
        let gaps = FireballEntity.gapPositions
        
        XCTAssert(gaps.count == Int((1000 - 100) / fireball.spriteComponent.node.texture!.size().width), "Unable to create press ended texture")
        
    }
    
}