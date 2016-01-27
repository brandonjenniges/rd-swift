//
//  Copyright (c) 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate, ControlPadTouches {
    
    var scenePaused = false
    
    enum Layer: CGFloat { case Background = 0; case Foreground = 1; case Game = 2; case Hud = 3; case GameOver = 4 }
    
    var viewController:GameViewController!
    
    var player:PlayerEntity!
    var platform:SKSpriteNode!
    var background:SKSpriteNode!
    var scoreLabel:SKLabelNode!
    var control: ControlPad!
    
    var gapPositions = [CGFloat]()
    
    var score = 0
    
    var pauseNode: SKSpriteNode!
    
    lazy var gameState: GKStateMachine = GKStateMachine(states: [
        IntroState(scene: self),
        PlayingState(scene: self),
        GameOverState(scene: self)
    ])
    
    var deltaTime: NSTimeInterval = 0
    var lastUpdatedTimeInterval: NSTimeInterval = 0
    
    override init(size: CGSize) {
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = .zero
        
        #if DEBUG
            self.view!.showsPhysics = true
        #endif
        
        #if os(tvOS)
            viewController.controllerUserInteractionEnabled = false
        #endif
        
        gameState.enterState(IntroState)
    }
    
    // MARK: - Touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        if scenePaused {
            unPauseScene()
        }
        
        gameState.currentState?.handleTouches(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        #if os(tvOS)
        if gameState.currentState is PlayingState {
            player.movePlayer(touches)
        }
        #endif
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        #if os(iOS)
        self.control.touchesEnded(touches, withEvent: event)
        #endif

        #if os(tvOS)
        if gameState.currentState is PlayingState {
            player.stopRunning()
            player.movement = .Neutral
        }
        #endif
    }
   
    // MARK: - Game Logic
    
    override func update(currentTime: CFTimeInterval) {
        if lastUpdatedTimeInterval == 0 {
            lastUpdatedTimeInterval = currentTime
        }
        
        deltaTime = currentTime - lastUpdatedTimeInterval
        lastUpdatedTimeInterval = currentTime
        
        gameState.updateWithDeltaTime(deltaTime)
    }
    
    // MARK: - Fireballs
    
    func addFireball() {
        let fire = FireballEntity()
        fire.setInitialPosition(gapPositions, background: background)
        addChild(fire.spriteComponent.node)
        fire.send(-background.frame.size.height / 2) //Needs this because of worldNode's anchor point
    }
    
    // MARK: - Scoring
    
    func updateScore() {
        enumerateChildNodesWithName(String(FireballEntity), usingBlock: { node, stop in
            if let fireball = node as? SKSpriteNode {
                if let passed = fireball.userData?["Passed"] as? NSNumber {
                    if passed.boolValue {
                        return
                    }
                }
                
                let playerNode = self.player.spriteComponent.node
                
                if playerNode.position.y - playerNode.size.height / 2 > fireball.position.y + fireball.size.height / 2 {
                    self.score++
                    self.scoreLabel.text = "\(self.score)"
                    fireball.userData?["Passed"] = NSNumber(bool: true)
                }
            }
        })
    }
    
    func resetScore() {
        score = 0
        scoreLabel.removeFromParent()
    }
    
    func reportScoreToGameCenter() {
        print("Reported score to gamecenter")
        GameKitHelper.sharedGameKitHelper.reportScore(score, leaderboardId: "846237154.gamecenter_leaderboard_main1")
    }
    
    func showLeaderboard() {
        GameKitHelper.sharedGameKitHelper.showGKGameCenterViewController(viewController)
    }
    
    // MARK: - Collision
    
    func didBeginContact(contact: SKPhysicsContact) {
        gameState.enterState(GameOverState)
    }
    
    // MARK - Game Logic Protocol
    
    func gameEventShouldUpdate() {
        if gameState.currentState is PlayingState {
            addFireball()
        }
    }
    
    // MARK: - Game elements
    
    func createBackground() {
        background = Background.create(self)
    }
    
    func createPlatform() {
        platform = Platform.create(self)
    }
    
    func addScoreLabel() {
        scoreLabel = ScoreLabel.create(self)!
    }
    
    func addTapToStart() {
        addChild(IntroGraphic.create(self)!)
    }
    
    func restartGame() {
        let newScene = GameScene(size: size)
        let transition = SKTransition.fadeWithColor(.blackColor(), duration: 0.02)
        view?.presentScene(newScene, transition: transition)
    }
    
    // MARK: - Element setup
    
    func setupPlayer() {
        player = PlayerEntity()
        player.setPlayerMovementXConstraints((self.platform.position.x + self.platform.frame.width / 2) - player.spriteComponent.node.frame.width / 2, min: (self.platform.position.x - self.platform.frame.size.width / 2) + player.spriteComponent.node.frame.width / 2)
        player.previousPlayerTouch = (self.view?.frame.width)! / 2
        resetPlayer()
        addChild(player.spriteComponent.node)
    }
    
    func resetPlayer() {
        player.spriteComponent.node.position = CGPointMake(self.platform.position.x, self.platform.position.y + (self.platform.size.height / 2) + (player.spriteComponent.node.size.height / 2) - 5)
    }
    
    func setupDragons() {
        
        let dragonArray = Dragon.getDragonArray()
        
        let gapSize = view!.frame.width / CGFloat(2)
        let topYPos = view!.frame.size.height * 0.75
        
        (0...1).forEach {
            let xPos = gapSize * CGFloat($0 * 1) + gapSize / 2
            let dragon = dragonArray[$0]
            dragon.setUpDragonAnimations()
            dragon.position = CGPointMake(xPos, topYPos)
            addChild(dragon)
        }
    }
    
    func resetDragons() {
        scene!.enumerateChildNodesWithName(Dragon.nodeName) {
            node, stop in
            node.removeFromParent()
        }
    }
    
    func setupControlPad() {
        control = ControlPad(texture: nil, size: CGSizeMake(CGRectGetWidth(self.frame), 80.0))
        control.delegate = self
        control.anchorPoint = .zero
        control.position = .zero
        addChild(control)
    }
    
    func setupGaps() {
        var tempArray = [CGFloat]()
        
        let groundStart = platform.position.x - platform.frame.size.width / 2
        (0...12).forEach {
            tempArray.append(groundStart + CGFloat(($0 * Int(platform.frame.size.width / 12))))
        }
        gapPositions = tempArray
    }
    
    // MARK: - Scene pausing
    
    func pauseScene() {
        scenePaused = true
        background.paused = true
        if let overlayScene = SKScene(fileNamed: "PauseScene") {
            let contentTemplateNode = overlayScene.childNodeWithName("Overlay") as! SKSpriteNode
            
            // Create a background node with the same color as the template.
            pauseNode = SKSpriteNode(color: contentTemplateNode.color, size: contentTemplateNode.size)
            pauseNode.zPosition = 10
            pauseNode.position = CGPointMake(pauseNode.frame.size.width / 2, pauseNode.frame.size.height / 2)
            
            // Copy the template node into the background node.
            let contentNode = contentTemplateNode.copy() as! SKSpriteNode
            pauseNode.addChild(contentNode)
            
            // Set the content node to a clear color to allow the background node to be seen through it.
            contentNode.color = .clearColor()
            contentNode.position = .zero
            
            addChild(pauseNode)
        }
    }
    
    func unPauseScene() {
        scenePaused = false
        background.paused = false
        if let pauseNode = pauseNode {
            pauseNode.removeFromParent()
        }
    }
    
    // MARK: - Control Pad
    
    func controlPadDidBeginTouch(direction: ControlPadTouchDirection) {
        #if os(iOS)
            if gameState.currentState is PlayingState {
                player.movePlayer(direction)
            }
        #endif
    }
    
    func controlPadDidEndTouch() {
        
    }
    
}
