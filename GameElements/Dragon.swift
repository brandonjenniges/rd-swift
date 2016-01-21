//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit
import GameKit

class Dragon: SKSpriteNode {
    
    static let nodeName = String(Dragon)
    let dragonID:Int
    
    init(dragonID: Int) {
        self.dragonID = dragonID
        let textureName = "dragon\(dragonID)_\(0)"
        let texture = TextureAtlasManager.dragonAtlas.textureNamed(textureName)
        super.init(texture: texture, color: .clearColor(), size: texture.size())
        self.name = Dragon.nodeName
        self.zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Animation
    
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
    
    static func getDragonArray() -> [Dragon] {
        let dragons = [Dragon(dragonID: 0), Dragon(dragonID: 1), Dragon(dragonID: 2), Dragon(dragonID: 3)]
        let shuffledArray:[Dragon]
        if #available(iOS 9.0, *) {
            shuffledArray = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(dragons.map { $0 }) as! [Dragon]
            
          //  shuffedArray = Dragon.dragons.map { $0 }
        } else {
            shuffledArray = dragons.map { $0 }
        }
        
        #if os(tvOS)
            shuffledArray[1].xScale = -1
            shuffledArray[3].xScale = -1
        #else
            shuffledArray[1].xScale = -1
            shuffledArray[3].xScale = -1
        #endif
        
        return shuffledArray
    }
}
