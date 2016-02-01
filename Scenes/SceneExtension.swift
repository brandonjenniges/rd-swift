//
//  SceneExtension.swift
//  Rampaging Dragons
//
//  Created by Brandon Jenniges on 1/30/16.
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import SpriteKit
import UIKit

extension SKScene {
    
    func rateApp() {
        let urlString = "https://itunes.apple.com/app/flappy-felipe/id\(846237154)?mt=8"
        let url = NSURL(string: urlString)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func showLeaderboard(viewController: UIViewController) {
        GameKitHelper.sharedGameKitHelper.showGKGameCenterViewController(viewController)
    }
    
    func buttonFadeInAnimation(delay: Double) -> SKAction {
        let action = SKAction.sequence([SKAction.waitForDuration(0.3 * delay), SKAction.fadeInWithDuration(0.3)])
        action.timingMode = .EaseInEaseOut
        return action
    }
}
