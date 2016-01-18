//
//  Copyright (c) 2015 Brandon Jenniges. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate, ControlPadTouches, GameLogicProtocol, FireballDelegate {
    
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
    var scoreLabel:SKLabelNode!
    var control: ControlPad!
    
    var gameState:GameState?
    var gapPositions = [CGFloat]()
    
    var score = 0
    
    var pauseNode: SKSpriteNode!
    
    var gameHandler:GameLogic!
    
    override init(size: CGSize) {
        super.init(size: size)
        gameHandler = GameLogic(scene: self)
        gameHandler.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        
        #if DEBUG
            self.view!.showsPhysics = true
        #endif
        
        #if os(tvOS)
            viewController.controllerUserInteractionEnabled = false
        #endif
        
        switchToIntro()
        
        createBackground()
        createPlatform()
        setupGaps()
        setupPlayer()
        
    }
    
    // MARK: - Touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        if scenePaused {
            unPauseScene()
        }
        
        if let gameState = gameState {
            switch gameState {
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
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        #if os(tvOS)
        if gameState == .Play {
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
        if gameState == .Play {
            player.stopRunning()
            player.movement = .Neutral
        }
        #endif
    }
   
    // MARK: - Game Logic
    
    override func update(currentTime: CFTimeInterval) {
        gameHandler.update(currentTime)
    }
    
    // MARK: - Fireballs
    
    func addFireball() {
        let fire = Fireball(texture: TextureAtlasManager.fireTextureAtlas.textureNamed("fireball1"))
        fire.setInitialPosition(gapPositions, background: background)
        background.addChild(fire)
        fire.send(-background.frame.size.height / 2) //Needs this because of worldNode's anchor point
    }
    
    // MARK: - Fireball Delegate
    
    func fireballDidReachDestination() {
        if gameState == .Play {
            increaseScore()
        }
    }
    
    // MARK: - Scoreing
    
    func increaseScore() {
        score++
        scoreLabel.text = "\(score)"
    }
    
    func resetScore() {
        score = 0
        scoreLabel.text = "\(score)"
    }
    
    // MARK: - Collision
    
    func didBeginContact(contact: SKPhysicsContact) {
        if gameState == .Play {
            gameState = .ShowingScore
            switchToGameOver()
        }
    }
    
    // MARK - Game Logic Protocol
    
    func gameEventShouldUpdate() {
        if gameState == .Play {
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
    
    // MARK: - Game states
    
    func switchToIntro() {
        gameState = .Intro
        addTapToStart()
        //resetPlayer()
    }
    
    func switchToPlay() {
        
        IntroGraphic.remove(self)
        
        addScoreLabel()
        setupDragons()
        
        #if os(iOS)
            setupControlPad()
        #endif
        
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
        
        player.die()
    }
    
    func startNewGame() {
        let gameOverNode = background.childNodeWithName("GameOverOverlay")
        gameOverNode!.removeFromParent()
        resetScore()
        switchToIntro()
    }
    
    // MARK: - Element setup
    
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
        
        (0...1).forEach {
            let xPos = gapSize * CGFloat($0 * 1) + gapSize / 2
            let dragon = dragonArray[$0]
            dragon.setUpDragonAnimations()
            dragon.position = CGPointMake(xPos, topYPos)
            addChild(dragon)
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
            if gameState == .Play {
                player.movePlayer(direction)
            }
        #endif
    }
    
    func controlPadDidEndTouch() {
    }
    
}
