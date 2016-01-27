//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import XCTest
import SpriteKit
@testable import RampagingDragons

class DragonEntityTests: XCTestCase {
    
    let dragonEntity = DragonEntity(dragonID: 0)
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreate() {
        let dragonEntity0 = DragonEntity(dragonID: 0)
        XCTAssertNotNil(dragonEntity0, "Unable to create dragon with id = 0")
        
        let dragonEntity1 = DragonEntity(dragonID: 1)
        XCTAssertNotNil(dragonEntity1, "Unable to create dragon with id = 1")
        
        let dragonEntity2 = DragonEntity(dragonID: 2)
        XCTAssertNotNil(dragonEntity2, "Unable to create dragon with id = 2")
        
        let dragonEntity3 = DragonEntity(dragonID: 3)
        XCTAssertNotNil(dragonEntity3, "Unable to create dragon with id = 3")
        
        dragonEntity0.setUpDragonAnimations()
        dragonEntity1.setUpDragonAnimations()
        dragonEntity2.setUpDragonAnimations()
        dragonEntity3.setUpDragonAnimations()
    }
    
    func testBaseAttributesSetup() {
        XCTAssert(dragonEntity.spriteComponent.node.name == String(DragonEntity), "Expected \(String(DragonEntity)) for node name but instead had \(dragonEntity.spriteComponent.node.name)")
        XCTAssert(dragonEntity.spriteComponent.node.zPosition == GameLayer.Layer.Foreground.rawValue, "Expected \(GameLayer.Layer.Foreground) for zPosition but instead had \(dragonEntity.spriteComponent.node.zPosition)")
    }
    
    // MARK: - Animation
    
    func testGetFlyingAnimationTexture() {
        let animationTextures = dragonEntity.getFlyingAnimationTextures()
        XCTAssert(animationTextures.count > 0, "Received no animation textures when trying to create flying animation")
    }
    
    func testGetFadeInAnimation() {
        let fadeInAnimation = dragonEntity.getFadeInAnimation()
        XCTAssertNotNil(fadeInAnimation, "Unable to create fade in animation")
    }
    
    func testGetWobbleAnimation() {
        let wobbleAnimation = dragonEntity.getWobbleAnimation()
        XCTAssertNotNil(wobbleAnimation, "Unable to create wobble animation")
    }
    
    // MARK: - Texture getters
    
    func testGetBaseTextureForDragonID() {
        let baseTexture = dragonEntity.getBaseTextureForDragonID(dragonEntity.dragonID)
        XCTAssertNotNil(baseTexture, "Unable to create base texture")
    }
    
    func testGetTextureForDragonID() {
        let initialTexture = dragonEntity.getTextureForDragonID(dragonEntity.dragonID, frame: 0)
        XCTAssertNotNil(initialTexture, "Unable to create inital texture")
        
        let maxTexture = dragonEntity.getTextureForDragonID(dragonEntity.dragonID, frame: dragonEntity.getFlyingAnimationTextures().count - 1)
        XCTAssertNotNil(maxTexture, "Unable to create max texture")
    }
    
    // MARK: - Utily 
    
    func testGetDragonArray() {
        let dragonArray = DragonEntity.getDragonArray()
        XCTAssert(dragonArray.count > 0, "Unable to create dragon array")
    }
}