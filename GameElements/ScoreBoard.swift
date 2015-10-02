//
//  ScoreBoard.swift
//  Rampaging Dragons
//
//  Created by Brandon Jenniges on 9/30/15.
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit

class ScoreBoard: SKSpriteNode {

    func setupWithGameScore(score:Int) {
        ScoreManager.saveHighScore(score)
        
        let bestScoreLabel = childNodeWithName("bestScore") as! SKLabelNode
        let currentScoreLabel = childNodeWithName("currentScore") as! SKLabelNode
        
        bestScoreLabel.text = "\(ScoreManager.getHighScore())"
        currentScoreLabel.text = "\(score)"
    }
    
}
