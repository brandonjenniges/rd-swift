//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit
import GameKit

class DragonEntity: GKEntity {
    
    static let nodeName = String(DragonEntity)
    let dragonID:Int
    
    var spriteComponent: SpriteComponent!
    
    init(dragonID: Int) {
        self.dragonID = dragonID
        super.init()
        
        let textureName = "dragon\(dragonID)_\(0)"
        let texture = TextureAtlasManager.dragonAtlas.textureNamed(textureName)
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        spriteComponent.node.name = DragonEntity.nodeName
        spriteComponent.node.zPosition = GameLayer.Layer.Foreground.rawValue
    }
    
    // MARK: - Animation
    
    func setUpDragonAnimations() {
        spriteComponent.node.runAction(getWobbleAnimation(), withKey: "wobble")
        spriteComponent.node.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(getFlyingAnimationTextures(), timePerFrame: 0.10)), withKey: "flying")
        spriteComponent.node.runAction(getFadeInAnimation(), withKey: "enter")
    }
    
    func getFadeInAnimation() -> SKAction {
        let scaleXTo:CGFloat = spriteComponent.node.xScale
        let group = SKAction.group([SKAction.scaleXTo(scaleXTo, duration: 5.0),SKAction.scaleYTo(spriteComponent.node.yScale, duration: 5.0)])
        group.timingMode = .EaseInEaseOut
        spriteComponent.node.setScale(0)
        return SKAction.sequence([SKAction.waitForDuration(0.3), group])
    }
    
    func getFlyingAnimationTextures() -> [SKTexture] {
        var array = [SKTexture]()
        
        [0, 1, 2, 3, 2, 1].forEach {
            let texture = getTextureForDragonID(dragonID, frame: $0)
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
    
    // MARK : Texture getters
    
    func getBaseTextureForDragonID(dragonID:Int) -> SKTexture {
        return getTextureForDragonID(dragonID, frame: 0)
    }
    
    func getTextureForDragonID(dragonID:Int, frame:Int) -> SKTexture {
        let textureName = "dragon\(dragonID)_\(frame)"
        return TextureAtlasManager.dragonAtlas.textureNamed(textureName)
    }
    
    // MARK: - Utility
    
    static func getDragonArray() -> [DragonEntity] {
        let dragons = [DragonEntity(dragonID: 0), DragonEntity(dragonID: 1), DragonEntity(dragonID: 2), DragonEntity(dragonID: 3)]
        let shuffledArray:[DragonEntity] = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(dragons.map { $0 }) as! [DragonEntity]
            
        #if os(tvOS)
            shuffledArray[1].spriteComponent.node.xScale = -1
            shuffledArray[3].spriteComponent.node.xScale = -1
        #else
            shuffledArray[1].spriteComponent.node.xScale = -1
            shuffledArray[3].spriteComponent.node.xScale = -1
        #endif
        
        return shuffledArray
    }
}
