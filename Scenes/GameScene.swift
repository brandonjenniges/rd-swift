//
//  Copyright (c) 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate, ControlPadTouches {
    
    static let fireballCategory:UInt32 = 0x1 << 0
    static let playerCategory:UInt32 = 0x1 << 1
    static let floorCategory:UInt32 = 0x1 << 2
    
    var scenePaused = false
    
    enum GameState { case Intro; case Play; case ShowingScore; case GameOver }
    enum Layer: CGFloat { case Background = 0; case Foreground = 1; case Game = 2; case Hud = 3; case GameOver = 4 }
    
    var viewController:GameViewController!
    
    var player:Player!
    var platform:SKSpriteNode!
    var background:SKSpriteNode!
    var scoreLabel:ScoreLabel!
    var control: ControlPad!
    
    var gameState:GameState?
    var gapPositions = [CGFloat]()
    
    var lastUpdateTime:NSTimeInterval?
    var dt:NSTimeInterval?
    var lastUpdateTimeInterval:NSTimeInterval = 0
    var lastSpawnTimeInterval:NSTimeInterval = 0
    var score = 0
    
    var pauseNode: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        
        #if DEBUG
            self.view!.showsPhysics = true
        #endif
        
        #if os(tvOS)
            viewController.controllerUserInteractionEnabled = false
        #endif
        
        gameState = .Intro
        
        addBackground()
        addPlatform()
        addScoreLabel()
        setupGaps()
        setupPlayer()
        setupDragons()
        
        #if os(iOS)
        setupControlPad()
        #endif
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        if scenePaused {
            unPauseScene()
        }
        
        let state:GameState = gameState!
        switch state {
        case .Intro:
            switchToPlay()
            break
        case .Play:
            #if os(iOS)
            self.control.touchesBegan(touches, withEvent: event)
            #endif
            break
        case .ShowingScore:
            break
        case .GameOver:
            startNewGame()
            break
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        let state:GameState = gameState!
        if state == .Play {
            player.movePlayer(touches)
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        #if os(iOS)
        self.control.touchesEnded(touches, withEvent: event)
        #endif

        if gameState == .Play {
            player.stopRunning()
            player.movement = .Neutral
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
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
            if gameState == .Play {
                addFireball()
            }
        }
    }
    
    //MARK: Game elements
    func addBackground() {
        background = SKSpriteNode(color: UIColor(red: 126/255.0, green: 200/255.0, blue: 219/255.0, alpha: 1.0), size: view!.frame.size)
        
        
        let cloud = SKSpriteNode(texture:TextureAtlasManager.introAtlas.textureNamed("cloud"))
        let numberOfClouds = Int(ceil(view!.frame.size.width / cloud.size.width))
        
        let clouds = SKSpriteNode()
        clouds.anchorPoint = CGPointMake(0.5, 0.5)
        clouds.size = CGSizeMake(CGFloat(numberOfClouds) * cloud.size.width, cloud.size.height)
        for index in 1...numberOfClouds {
            let c = cloud.copy() as! SKSpriteNode
            c.anchorPoint = CGPointMake(0, 0.5)
            c.position = CGPointMake((CGFloat(index - 1) * c.frame.size.width) - clouds.size.width / 2, 0)
            clouds.addChild(c)
        }
        clouds.position = CGPointMake(0, 0)
        background.addChild(clouds)
        
        let bottomClouds = SKSpriteNode(color: UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.4), size: CGSizeMake(view!.frame.size.width, view!.frame.size.height / 2 - clouds.frame.origin.y))
        bottomClouds.position = CGPointMake(0, -(clouds.frame.size.height / 2) - bottomClouds.frame.size.height / 2)
        background.addChild(bottomClouds)
        
        background.position = CGPointMake(view!.frame.width / 2, view!.frame.height / 2)
        addChild(background)
    }
    
    func addPlatform() {
        platform = SKSpriteNode(texture: TextureAtlasManager.playerAtlas.textureNamed("ground"))
        platform.position = CGPointMake(view!.frame.width / 2, view!.frame.height / 4)
        print(platform.texture?.size())
        platform.zPosition = 1
        addChild(platform)
    }
    
    func addScoreLabel() {
        scoreLabel = ScoreLabel()
        scoreLabel.position = CGPointMake(view!.frame.width / 2, view!.frame.height * 0.75)
        addChild(scoreLabel)
    }
    
    //MARK: Game states
    func switchToIntro() {
        self.gameState = .Intro
        resetPlayer()
    }
    
    func switchToPlay() {
        self.gameState = .Play
        
        /*
        let intro = worldNode.childNodeWithName("intro")
        let removeIntroAction = SKAction.fadeAlphaTo(0, duration: 2.0)
        intro?.runAction(removeIntroAction, completion: { () -> Void in
           // let moveRightAction = SKAction.moveToX(700, duration: 2.0)
           // self.player.runAction(moveRightAction)
        })
        */
        
        
    }
    
    func switchToGameOver() {
        
        let overlay = SKSpriteNode(color: UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.5), size: view!.frame.size)
        overlay.name = "GameOverOverlay"
        overlay.zPosition = Layer.GameOver.rawValue
        background.addChild(overlay)
        
        let scorecard = ScoreBoard(score: score)
        scorecard.position = CGPointMake(0, -view!.frame.size.height + -scorecard.frame.size.height)
        overlay.addChild(scorecard)
        let moveAction = SKAction.moveToY(0, duration: 0.4)
        scorecard.runAction(moveAction) { () -> Void in
            self.gameState = .GameOver
        }
        
        let gameover = SKSpriteNode(texture: TextureAtlasManager.gameOverAtlas.textureNamed("gameover"))
        gameover.position = CGPointMake(0, view!.frame.size.height / 4)
        overlay.addChild(gameover)
        
        let playButton = SKSpriteNode(texture: TextureAtlasManager.introAtlas.textureNamed("play"))
        playButton.position = CGPointMake(0, -(view!.frame.size.height / 4))
        overlay.addChild(playButton)
        
        self.player.die()
    }
    
    func startNewGame() {
        let gameOverNode = background.childNodeWithName("GameOverOverlay")
        gameOverNode!.removeFromParent()
        resetScore()
        switchToIntro()
    }
    
    //MARK: Elements
    func setupPlayer() {
        player = Player()
        player.setPlayerRightMovementMax((self.platform.position.x + self.platform.frame.width / 2) - player.frame.width / 2, min: (self.platform.position.x - self.platform.frame.size.width / 2) + player.frame.width / 2)
        player.previousPlayerTouch = (self.view?.frame.width)! / 2
        resetPlayer()
        addChild(player)
    }
    
    func resetPlayer() {
        player.position = CGPointMake(self.platform.position.x, self.platform.position.y + (self.platform.size.height / 2) + (player.size.height / 2) - 10)
    }
    
    func setupDragons() {
        
        let dragonArray = Dragon.getDragonArray()
        
        let gapSize = view!.frame.width / CGFloat(2)
        let topYPos = view!.frame.size.height * 0.75
        
        for index in 0...1 {
            let xPos = gapSize * CGFloat(index * 1) + gapSize / 2
            let dragon = dragonArray[index]
            dragon.setUpDragonAnimations()
            dragon.position = CGPointMake(xPos, topYPos)
            addChild(dragon)
        }
    }
    
    func setupControlPad() {
        control = ControlPad(texture: nil, size: CGSizeMake(CGRectGetWidth(self.frame), 100.0))
        control.delegate = self
        control.anchorPoint = CGPointMake(0, 0)
        control.position = CGPointMake(0, 0)
        addChild(control)
    }
    
    func setupGaps() {
        var tempArray = [CGFloat]()
        
        let groundStart = platform.position.x - platform.frame.size.width / 2
        for index in 0...12 {
            tempArray.append(groundStart + CGFloat((index * Int(platform.frame.size.width / 12))))
        }
        gapPositions = tempArray
    }
    
    func addFireball() {
        let fire = Fireball(texture: TextureAtlasManager.fireTextureAtlas.textureNamed("fireball1"))
        fire.setupFireball()
        fire.zPosition = CGFloat(Layer.Game.rawValue)
        
        let x = gapPositions[Int(arc4random_uniform(12))] + fire.size.width / 2
        fire.position = CGPointMake(x - background.frame.size.width / 2, frame.size.height + frame.size.height / 2.0)
        fire.setupPhysicsBody()
        fire.zPosition = Layer.Game.rawValue
        background.addChild(fire)
        fire.send(-background.frame.size.height / 2) //Needs this because of worldNode's anchor point
    }
    
    func increaseScore() {
        score++
        scoreLabel.text = "\(score)"
    }
    
    func resetScore() {
        score = 0
        scoreLabel.text = "\(score)"
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if self.gameState == .Play {
            self.gameState = .ShowingScore
            switchToGameOver()
        }
    }
    
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
            
            scene?.addChild(pauseNode)
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
        print("Start \(direction)")
    }
    
    func controlPadDidEndTouch() {
        print("Done")
    }
    
}
