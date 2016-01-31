//
//  Copyright (c) 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate, ControlPadTouches {
    
    let worldNode = SKNode()
    
    var viewController:GameViewController!
    
    var player:PlayerEntity!
    var platform:SKSpriteNode!
    var background:SKSpriteNode!
    var scoreLabel:SKLabelNode!
    var control: ControlPad!
    var playButton: SKSpriteNode!
    var gameCenterButton: SKSpriteNode!
    var rateButton: SKSpriteNode!
    
    var score = 0
    
    lazy var gameState: GKStateMachine = GKStateMachine(states: [
        IntroState(scene: self),
        PlayingState(scene: self),
        GameOverState(scene: self)
    ])
    
    var deltaTime: NSTimeInterval = 0
    var lastUpdatedTimeInterval: NSTimeInterval = 0
    
    init(size: CGSize, viewController: GameViewController, background: SKSpriteNode?) {
        self.viewController = viewController
        self.background = background
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = .zero
        
        #if os(tvOS)
            viewController.controllerUserInteractionEnabled = false
        #endif
        
        addChild(worldNode)
        
        gameState.enterState(IntroState)
    }
    
    // MARK: - Touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        gameState.currentState?.handleTouches(touches, withEvent: event)
    }
    
    
    #if os(tvOS)
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        if gameState.currentState is PlayingState {
            player.movePlayer(touches)
        }
    }
    #endif
    
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
    
    func updateClouds() {
        background.enumerateChildNodesWithName("cloud", usingBlock: { node, stop in
            if let cloud = node as? SKSpriteNode {
                let moveAmount = CGPointMake(-2 * CGFloat(self.deltaTime), 0)
                cloud.position.x += moveAmount.x
                
                if cloud.position.x < -cloud.size.width + -self.size.width / 2 {
                    let numberOfClouds = Int(self.size.width / cloud.size.width) + 2
                    cloud.position.x += cloud.size.width * CGFloat(numberOfClouds)
                }
            }
        })
    }
    
    // MARK: - Fireballs
    
    func addFireball() {
        let fire = FireballEntity()
        fire.setInitialPosition(background.frame.size.height + background.frame.size.height / 2.0)
        worldNode.addChild(fire.spriteComponent.node)
        fire.send(0)
    }
    
    // MARK: - Scoring
    
    func updateScore() {
        worldNode.enumerateChildNodesWithName(String(FireballEntity), usingBlock: { node, stop in
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
    
    func reportScoreToGameCenter() {
        print("Reported score to gamecenter")
        GameKitHelper.sharedGameKitHelper.reportScore(score, leaderboardId: "846237154.gamecenter_leaderboard_main1")
    }
    
    func showLeaderboard() {
        GameKitHelper.sharedGameKitHelper.showGKGameCenterViewController(viewController)
    }
    
    // MARK: - Collision
    
    func didBeginContact(contact: SKPhysicsContact) {
        if let fire = contact.bodyA.categoryBitMask == PhysicsCategory.Fireball ? contact.bodyA.node : contact.bodyB.node {
            fire.removeFromParent()
        }
        
        gameState.enterState(GameOverState)
    }
    
    // MARK: - Setup Methods
    
    func setupBackground() {
        // This allows us to keep clouds in same position when starting a new game
        if background == nil {
            background = Background.create(self)
        } else {
            background = background.copy() as! SKSpriteNode
        }
        worldNode.addChild(background)
    }
    
    func setupGround() {
        platform = Platform.create(self)
        worldNode.addChild(platform)
        
        let mountain = Mountain.create(self, platform: platform)
        worldNode.addChild(mountain)
    }
    
    func setupScoreLabel() {
        scoreLabel = ScoreLabel.create(self)!
        worldNode.addChild(scoreLabel)
    }
    
    func setupTutorial() {
        let intro = IntroGraphic.create(self)
        worldNode.addChild(intro)
    }
    
    func setupPlayer() {
        player = PlayerEntity()
        player.setPlayerMovementXConstraints((self.platform.position.x + self.platform.frame.width / 2) - player.spriteComponent.node.frame.width / 2, min: (self.platform.position.x - self.platform.frame.size.width / 2) + player.spriteComponent.node.frame.width / 2)
        player.previousPlayerTouch = (self.view?.frame.width)! / 2
        player.spriteComponent.node.position = CGPointMake(self.platform.position.x, self.platform.position.y + (self.platform.size.height / 2) + (player.spriteComponent.node.size.height / 2) - 5)
        worldNode.addChild(player.spriteComponent.node)
    }
    
    func setupDragons() {
        
        let dragonArray = DragonEntity.getDragonArray()
        
        let gapSize = scene!.size.width / CGFloat(2)
        let topYPos = scene!.size.height * 0.75
        
        (0...1).forEach {
            let xPos = gapSize * CGFloat($0 * 1) + gapSize / 2
            let dragon = dragonArray[$0]
            dragon.setUpDragonAnimations()
            dragon.spriteComponent.node.position = CGPointMake(xPos, topYPos)
            worldNode.addChild(dragon.spriteComponent.node)
        }
    }
    
    func setupControlPad() {
        let controlTexture = TextureAtlasManager.sceneAtlas.textureNamed("control")
        control = ControlPad(texture: controlTexture, size: CGSizeMake(controlTexture.size().width * 2, controlTexture.size().height))
        control.delegate = self
        control.anchorPoint = .zero
        control.position = .zero
        worldNode.addChild(control)
    }
    
    func setupScoreCard() {
        let scorecard = ScoreBoard(score: score)
        scorecard.position = CGPointMake(size.width / 2, -size.height + -scorecard.frame.size.height)
        worldNode.addChild(scorecard)
        let moveAction = SKAction.moveToY(size.height / 2, duration: 0.4)
        scorecard.runAction(moveAction)
    }
    
    func setupGameOverLabel() {
        let gameover = SKSpriteNode(texture: TextureAtlasManager.gameOverAtlas.textureNamed("gameover"))
        gameover.zPosition = GameLayer.Layer.GameOver.rawValue
        gameover.position = CGPointMake(size.width / 2, size.height * 0.75)
        worldNode.addChild(gameover)
    }
    
    func setupPlayButton() {
        playButton = PlayButton.create(self)
        playButton.position = CGPointMake(size.width / 2, size.height / 4)
        worldNode.addChild(playButton)
    }
    
    func setupGameCenterButton() {
        gameCenterButton = Button.create(self)
        gameCenterButton.position = CGPointMake(gameCenterButton.size.width, gameCenterButton.size.height)
        addChild(gameCenterButton)
        
        let gameCenterIcon = GameCenterButton.create(self)
        gameCenterIcon.position = .zero
        gameCenterButton.addChild(gameCenterIcon)
    }
    
    func setupRateButton() {
        rateButton = Button.create(self)
        rateButton.position = CGPointMake(gameCenterButton.position.x + gameCenterButton.size.width * 1.5, gameCenterButton.position.y)
        addChild(rateButton)
        
        let rateIcon = RateButton.create(self)
        rateIcon.position = .zero
        rateButton.addChild(rateIcon)
    }
    
    // MARK: - Control Pad
    
    func controlPadDidBeginTouch(direction: ControlPadTouchDirection) {
        #if os(iOS)
            if gameState.currentState is PlayingState {
                player.movePlayer(direction)
            }
        #endif
    }
    
}
