//
//  Copyright © 2015 Brandon Jenniges. All rights reserved.
//

import Foundation

class ScoreManager {
    static let scoreKey = "kBestScoreKey"
    static let keystore = NSUbiquitousKeyValueStore()
    
    static func getHighScore() -> Int{
        let highScore = Int(ScoreManager.keystore.doubleForKey(scoreKey))
        return highScore
    }
    
    static func saveHighScore(score:Int) {
        let highScore = getHighScore()
        if score > highScore {
            ScoreManager.keystore.setDouble(Double(score), forKey: scoreKey)
            ScoreManager.keystore.synchronize()
        }
    }
}
