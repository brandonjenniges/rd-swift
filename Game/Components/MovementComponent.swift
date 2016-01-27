//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit
import GameplayKit

class MovementComponent: GKComponent {
    
    let spriteComponent: SpriteComponent
    
    init(entity: GKEntity) {
        self.spriteComponent = entity.componentForClass(SpriteComponent)!
    }
}
