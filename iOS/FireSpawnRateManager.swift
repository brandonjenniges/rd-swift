//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

struct FireSpawnRateManager {
    
    static func updateFireSpawnRate(firesAdded: Int) -> Double {
        var fireSpawnRate = 2.0
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
        return fireSpawnRate
    }
}