//
//  Copyright © 2016 Brandon Jenniges. All rights reserved.
//

import GameKit

let PresentAuthenticationViewController = "present_authentication_view_controller"

class GameKitHelper: NSObject, GKGameCenterControllerDelegate {
    
    var authenitcationViewController: UIViewController?
    var lastError: NSError?
    var enableGameCenter = true
    
    static let sharedGameKitHelper = GameKitHelper()
    
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController : UIViewController?, error : NSError?) -> Void in
            if let error = error {
                self.lastError = error
            }
            
            if let viewController = viewController {
                self.setAuthenticationViewController(viewController)
            } else if localPlayer.authenticated {
                self.enableGameCenter = true
            } else {
                self.enableGameCenter = false
            }
        }
    }
    
    func setAuthenticationViewController(viewController: UIViewController?) {
        if let viewController = viewController {
            authenitcationViewController = viewController
            NSNotificationCenter.defaultCenter().postNotificationName(PresentAuthenticationViewController, object: self)
        }
    }
    
    func reportScore(score: Int, leaderboardId: String) {
        if !enableGameCenter {
            print("Local play is not authenticated")
        }
        
        let scoreReporter = GKScore(leaderboardIdentifier: leaderboardId)
        scoreReporter.value = Int64(score)
        scoreReporter.context = 0
        
        let scores = [scoreReporter]
        GKScore.reportScores(scores) { (error: NSError?) -> Void in
            self.lastError = error
            print("GameKitHelper \(self.lastError?.userInfo.description)")
        }
    }
    
    func showGKGameCenterViewController(viewController: UIViewController) {
        if !enableGameCenter {
            print("Local play is not authenticated")
        }
        
        let gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        #if os(iOS)
        gameCenterViewController.viewState = .Leaderboards
        #endif
        viewController.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
