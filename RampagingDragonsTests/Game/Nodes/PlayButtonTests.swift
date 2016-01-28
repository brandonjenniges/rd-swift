//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import XCTest
import SpriteKit
@testable import RampagingDragons

class PlayButtonTests: XCTestCase {
    
    var scene = TestUtil.getMenuScene()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreate() {
        let playButton = PlayButton.create(scene)
        XCTAssertNotNil(playButton, "Unable to create play button")
    }
    
    func testPresses() {
        
        let pressTexture = PlayButton.press()
        XCTAssertNotNil(pressTexture, "Unable to create press texture")
        
        let pressDoneTexture = PlayButton.pressEnded()
        XCTAssertNotNil(pressDoneTexture, "Unable to create press ended texture")
    }
    
}