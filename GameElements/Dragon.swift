//
//  Dragon.swift
//  Launchy Demo
//
//  Created by Brandon Jenniges on 9/26/15.
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit

class Dragon: SKSpriteNode {
    
    static let dragonAtlas = SKTextureAtlas(named: "Dragons")
    static var dragonArray:[Dragon]!
    
    let DragonCategoryName = "dragon"
    
    init(imageName: String) {
        let texture = Dragon.dragonAtlas.textureNamed(imageName)
        print(texture.size())
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.name = DragonCategoryName
        self.zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpDragonAnimations(index: Int) {
        self.runAction(setupDragonWobbleAnimation(), withKey: "wobble")
        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(setUpDragonAnimationsMovementAnimation(index), timePerFrame: 0.10)))
        self.runFadeInAnimation()
    }
    
    func runFadeInAnimation() {
        let scaleXTo:CGFloat = self.xScale
        let group = SKAction.group([SKAction.scaleXTo(scaleXTo, duration: 5.0),SKAction.scaleYTo(self.yScale, duration: 5.0)])
        group.timingMode = .EaseInEaseOut
        self.setScale(0)
        self.runAction(SKAction.sequence([SKAction.waitForDuration(0.3), group]))
    }
    
    func setUpDragonAnimationsMovementAnimation(dragon: Int) -> [SKTexture] {
        //let texture = dragonAtlas.textureNamed("dragon1_1")
        var array = [SKTexture]()
        
        for index in 0...3 {
            let textureName = "dragon\(dragon)_\(index)"
            array.append(Dragon.dragonAtlas.textureNamed(textureName))
        }
        
        for var index = 2; index > 0; index-- {
            let textureName = "dragon\(dragon)_\(index)"
            array.append(Dragon.dragonAtlas.textureNamed(textureName))
        }
        return array
    }
    
    func setupDragonWobbleAnimation() -> SKAction {
        let moveUp = SKAction.moveByX(0, y: 10, duration: 0.4)
        moveUp.timingMode = .EaseInEaseOut
        let moveDown = moveUp.reversedAction()
        let sequence = SKAction.sequence([moveUp,moveDown])
        let wobble = SKAction.repeatActionForever(sequence)
        return wobble
    }
}
