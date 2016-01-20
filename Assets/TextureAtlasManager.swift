//
//  TextureAtlasManager.swift
//  Rampaging Dragons
//
//  Created by Brandon Jenniges on 10/9/15.
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit

class TextureAtlasManager: NSObject {
    
    //MARK: TextureAtlas
    static let playerAtlas = SKTextureAtlas(named: "Player")
    static let dragonAtlas = SKTextureAtlas(named: "Dragons")
    static let fireTextureAtlas = SKTextureAtlas(named: "Fire")
    static let introAtlas = SKTextureAtlas(named: "Intro")
    static let gameOverAtlas = SKTextureAtlas(named: "GameOver")
    static let sceneAtlas = SKTextureAtlas(named: "Scene")
    
    //MARK: playerAtlas textures
    static let player_looking_left = TextureAtlasManager.playerAtlas.textureNamed("looking_left")
    static let player_looking_right = TextureAtlasManager.playerAtlas.textureNamed("looking_right")
    static let player_0 = TextureAtlasManager.playerAtlas.textureNamed("player0")
    static let player_1 = TextureAtlasManager.playerAtlas.textureNamed("player1")
    static let player_2 = TextureAtlasManager.playerAtlas.textureNamed("player2")
    static let player_3 = TextureAtlasManager.playerAtlas.textureNamed("player3")
    static let player_4 = TextureAtlasManager.playerAtlas.textureNamed("player4")
    static let player_5 = TextureAtlasManager.playerAtlas.textureNamed("player5")
    static let player_6 = TextureAtlasManager.playerAtlas.textureNamed("player6")
    
}
