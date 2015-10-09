//
//  TextureAtlasManager.swift
//  Rampaging Dragons
//
//  Created by Brandon Jenniges on 10/9/15.
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit

class TextureAtlasManager: NSObject {
    static let playerAtlas = SKTextureAtlas(named: "Player")
    static let dragonAtlas = SKTextureAtlas(named: "Dragons")
    static let fireTextureAtlas = SKTextureAtlas(named: "Fire")
    static let introAtlas = SKTextureAtlas(named: "Intro")
    static let gameOverAtlas = SKTextureAtlas(named: "GameOver")
}
