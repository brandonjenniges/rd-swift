//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit
import GameplayKit

class PlayingState: GKState {
    unowned let scene: GameScene
    var lastSpawnTimeInterval: NSTimeInterval = 0
    
    var fireSpawnRate = 2.5
    var firesAdded = 0
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        scene.setupScoreLabel()
        scene.setupDragons()
        
        #if os(iOS)
            scene.setupControlPad()
        #endif
        
        IntroGraphic.remove(scene)
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is GameOverState.Type
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        lastSpawnTimeInterval += seconds
        if lastSpawnTimeInterval > fireSpawnRate {
            lastSpawnTimeInterval = 0
            scene.addFireball()
            firesAdded++
            updateFireSpawnRate()
        }
        scene.updateScore()
        scene.updateClouds()
    }
    
    // MARK: - State Touches
    
    override func handleTouches(touches: Set<UITouch>, withEvent event: UIEvent?) {
        #if os(iOS)
            scene.control.touchesBegan(touches, withEvent: event)
        #endif
    }
    
    func updateFireSpawnRate() {
        switch firesAdded {
        case 0...5:
            fireSpawnRate = 2
        case 6...10:
            fireSpawnRate = 1.3
        case 11...50:
            fireSpawnRate = 1.0
        case 51...99:
            fireSpawnRate = 0.8
        case 100...200:
            fireSpawnRate = 0.75
        case 201...500:
            fireSpawnRate = 0.6
        case 501...750:
            fireSpawnRate = 0.5
        case 751...1000:
            fireSpawnRate = 0.45
        case 1001...1500:
            fireSpawnRate = 0.40
        case 1501...2000:
            fireSpawnRate = 0.35
        case 2001...3000:
            fireSpawnRate = 0.30
        case 3000...5000:
            fireSpawnRate = 0.25
        case 5001...10000:
            fireSpawnRate = 0.20
        default:
            fireSpawnRate -= 0.001
            // Avoid negative
            if fireSpawnRate < 0 {
                fireSpawnRate = 0
            }
        }
    }
    
    /*
    - (void)calculateFireSpawnRate {
    if (firesAdded <= 5) {
    fireSpawnRate = 2.5f;
    } else if (firesAdded <= 20) {
    fireSpawnRate = 2.0f;
    } else if (firesAdded <= 30) {
    fireSpawnRate = 1.9f;
    } else if (firesAdded <= 50) {
    fireSpawnRate = 1.75f;
    } else if (firesAdded <= 75) {
    fireSpawnRate = 1.5f;
    } else if (firesAdded <= 100) {
    fireSpawnRate = 1.25f;
    } else if (firesAdded <= 150) {
    fireSpawnRate = 1.10f;
    } else if (firesAdded <= 200) {
    fireSpawnRate = 1.0f;
    } else {
    fireSpawnRate = fireSpawnRate - 0.001;
    }
    }
    */
}