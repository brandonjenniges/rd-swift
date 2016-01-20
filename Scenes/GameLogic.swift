//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit

protocol GameLogicProtocol {
    func gameEventShouldUpdate()
}

class GameLogic: NSObject {
    
    let scene: GameScene!
    
    var lastUpdateTime:NSTimeInterval?
    var dt:NSTimeInterval?
    var lastUpdateTimeInterval:NSTimeInterval = 0
    var lastSpawnTimeInterval:NSTimeInterval = 0
    
    var delegate: GameLogicProtocol?
    
    init(scene: GameScene) {
        self.scene = scene
        delegate = self.scene
    }
    
    func update(currentTime: CFTimeInterval) {
        
        if let lastUpdateTime = lastUpdateTime {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        
        lastUpdateTime = currentTime
        
        var timeSinceLast = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        
        if timeSinceLast > 1 {
            timeSinceLast = 1.0 / 60.0
            lastUpdateTimeInterval = currentTime
        }
        
        updateWithTimeSinceLastUpdate(timeSinceLast)
        
    }
    
    func updateWithTimeSinceLastUpdate(timeSinceLast:CFTimeInterval) {
        lastSpawnTimeInterval = timeSinceLast + lastSpawnTimeInterval
        if lastSpawnTimeInterval > 1 {
            lastSpawnTimeInterval = 0
            if let delegate = delegate {
                delegate.gameEventShouldUpdate()
            }
        }
    }
}
