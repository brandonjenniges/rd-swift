//
//  Dragon.swift
//  Launchy Demo
//
//  Created by Brandon Jenniges on 9/26/15.
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit
import GameKit

class Dragon: SKSpriteNode {
    
    static let dragons = [Dragon(dragonID: 0), Dragon(dragonID: 1), Dragon(dragonID: 2), Dragon(dragonID: 3)]
    
    let DragonCategoryName = "dragon"
    let dragonID:Int
    
    init(dragonID: Int) {
        self.dragonID = dragonID
        let textureName = "dragon\(dragonID)_\(0)"
        let texture = TextureAtlasManager.dragonAtlas.textureNamed(textureName)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.name = DragonCategoryName
        self.zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Animation
    func setUpDragonAnimations() {
        self.runAction(getWobbleAnimation(), withKey: "wobble")
        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(getFlyingAnimationTextures(), timePerFrame: 0.10)), withKey: "flying")
        self.runAction(getFadeInAnimation(), withKey: "enter")
    }
    
    func getFadeInAnimation() -> SKAction {
        let scaleXTo:CGFloat = self.xScale
        let group = SKAction.group([SKAction.scaleXTo(scaleXTo, duration: 5.0),SKAction.scaleYTo(self.yScale, duration: 5.0)])
        group.timingMode = .EaseInEaseOut
        self.setScale(0)
        return SKAction.sequence([SKAction.waitForDuration(0.3), group])
    }
    
    func getFlyingAnimationTextures() -> [SKTexture] {
        var array = [SKTexture]()
        
        for index in 0...3 {
            let texture = getTextureForDragonID(dragonID, frame: index)
            array.append(texture)
        }
        
        for var index = 2; index > 0; index-- {
            let texture = getTextureForDragonID(dragonID, frame: index)
            array.append(texture)
        }
        
        return array
    }
    
    func getWobbleAnimation() -> SKAction {
        let moveUp = SKAction.moveByX(0, y: 10, duration: 0.4)
        moveUp.timingMode = .EaseInEaseOut
        let moveDown = moveUp.reversedAction()
        moveDown.timingMode = .EaseInEaseOut
        let sequence = SKAction.sequence([moveUp,moveDown])
        let wobble = SKAction.repeatActionForever(sequence)
        return wobble
    }
    
    //MARK: Texture getters
    func getBaseTextureForDragonID(dragonID:Int) -> SKTexture {
        return getTextureForDragonID(dragonID, frame: 0)
    }
    
    func getTextureForDragonID(dragonID:Int, frame:Int) -> SKTexture {
        let textureName = "dragon\(dragonID)_\(frame)"
        return TextureAtlasManager.dragonAtlas.textureNamed(textureName)
    }
    
    //MARK: Utility
    static func getDragonArray() -> [Dragon] {
        let shuffedArray:[Dragon]
        if #available(iOS 9.0, *) {
            shuffedArray = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(Dragon.dragons.map { $0.copy() as! Dragon }) as! [Dragon]
        } else {
            shuffedArray = Dragon.dragons.map { $0.copy() as! Dragon }
        }
        
        // Make right most dragons scale to face towards center of screen
        #if os(tvOS)
            shuffedArray[2].xScale = -1
            shuffedArray[3].xScale = -1
        #else
            shuffedArray[1].xScale = -1
        #endif
        
        return shuffedArray
    }
}
