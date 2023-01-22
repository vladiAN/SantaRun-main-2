//
//  GameScene.swift
//  2DGame
//
//  Created by Андрушок on 05.01.2023.
//

import SpriteKit
import GameplayKit

struct BitMasks {
    static let hero: UInt32 = 1
    static let ground: UInt32 = 2
    static let enemy: UInt32 = 4
    static let presentBox: UInt32 = 8
}

class GameScene: SKScene {
    
    let sceneManager = SceneManager.shared
    
    var bgTexture: SKTexture!
    var heroTexture: SKTexture!
    var snowManTexture: SKTexture!
    var birdTexture: SKTexture!
    var presentBoxTexture: SKTexture!
    
    
    var bg = SKSpriteNode()
    var hero = SKSpriteNode()
    var ground = SKSpriteNode()
    var snowMan = SKSpriteNode()
    var bird = SKSpriteNode()
    var presentBox = SKSpriteNode()
    
    
    var bgObjeckt = SKNode()
    var heroObjeckt = SKNode()
    var groundObjeckt = SKNode()
    var generalSnowObjeckt = SKNode()
    var snowManObjeckt = SKNode()
    var birdObjeckt = SKNode()
    var presentBoxObjeckt = SKNode()
    
    var settingButton = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    let lifeHeart = SKTexture(imageNamed: "life")

    var life1 = SKSpriteNode()
    var life2 = SKSpriteNode()
    var life3 = SKSpriteNode()
    
    var lives = 3 {
        didSet{
            switch lives {
            case 3:
                life1.isHidden = false
                life2.isHidden = false
                life3.isHidden = false
            case 2:
                life1.isHidden = false
                life2.isHidden = false
                life3.isHidden = true
            case 1:
                life1.isHidden = false
                life2.isHidden = true
                life3.isHidden = true
            default:
                break
            }
        }
    }
    
    var onGround = true
    
    var heroRunTextureArray = Array(1...11).map { int in
        SKTexture(imageNamed: "Run (\(int))")
    }
    var heroJumpTextureArray = Array(1...16).map { int in
        SKTexture(imageNamed: "Jump (\(int))")
    }
    var heroSlideTextureArray = Array(1...11).map { int in
        SKTexture(imageNamed: "Slide (\(int))")
    }
    var snowManTextureArray = Array(1...7).map { int in
        SKTexture(imageNamed: "SnowManIdle\(int)")
    }
    var birdTextureArray = Array(1...16).map { int in
        SKTexture(imageNamed: "bird\(int)")
    }
    
    override func didMove(to view: SKView) {
        self.scene?.isPaused = false
        
        guard sceneManager.gameScene == nil else {return}
        
        sceneManager.gameScene = self
        
        physicsWorld.contactDelegate = self
  
        bgTexture = SKTexture(imageNamed: "bg winter")
        heroTexture = SKTexture(imageNamed: "Run (2)")
        snowManTexture = SKTexture(imageNamed: "SnowManIdle1")
        birdTexture = SKTexture(imageNamed: "bird0")
        presentBoxTexture = SKTexture(imageNamed: "present")
        
        createObjects()
        createGame()
        
    }
    
    func createObjects() {
        
        self.addChild(bgObjeckt)
        self.addChild(groundObjeckt)
        self.addChild(heroObjeckt)
        self.addChild(generalSnowObjeckt)
        self.addChild(snowManObjeckt)
        self.addChild(birdObjeckt)
        self.addChild(presentBoxObjeckt)
        
    }
    
    func createGame() {
        
        createBg()
        createGround()
        createHero()
        createGeneralSnow()
        createEnemy()
        setLabel()
        setPause()
        setLife()
        
        swipe()
        
    }
    
    // MARK: - Бекграунд
    func createBg() {
        bgTexture = SKTexture(imageNamed: "bg winter")
        
        let moveBg = SKAction.moveBy(x: -bgTexture.size().width, y: 0, duration: 5)
        let replaseBg = SKAction.moveBy(x: bgTexture.size().width, y: 0, duration: 0)
        let moveBrRepeat = SKAction.repeatForever(SKAction.sequence([moveBg, replaseBg]))
        
        for i in 0..<3 {
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width * CGFloat(i), y: size.height / 2)
            bg.size.height = self.frame.height
            bg.run(moveBrRepeat)
            bg.zPosition = -10
            
            bgObjeckt.addChild(bg)
            
        }
    }
    
    // MARK: - Земля
    func createGround() {
        ground = SKSpriteNode()
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 20))
        ground.position.y = self.position.y + 40
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = BitMasks.ground
        ground.physicsBody?.contactTestBitMask = BitMasks.hero
        ground.physicsBody?.restitution = 0.0
        ground.zPosition = 1
        
        groundObjeckt.addChild(ground)
    }
    
    // MARK: - Санта
    func addHero(heroNode: SKSpriteNode, atPosition position: CGPoint) {
        hero = SKSpriteNode(texture: heroTexture)
        
        let heroRunAnimation = SKAction.animate(with: heroRunTextureArray, timePerFrame: 0.1)
        let heroRun = SKAction.repeatForever(heroRunAnimation)
        hero.run(heroRun)
        
        hero.position = position
        hero.size.height = hero.size.height / 4
        hero.size.width = hero.size.width / 4
        
        hero.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: hero.size.width - 160, height: hero.size.height - 20),
                                         center: CGPoint(x: -20, y: 5))
        
        heroBitMaskSet()
        
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.allowsRotation = false
        hero.physicsBody?.restitution = 0.0
        hero.zPosition = 1
        
        heroObjeckt.addChild(hero)
    }
    
    func createHero() {
        addHero(heroNode: hero, atPosition: CGPoint(x: self.frame.minX + 120, y: ground.position.y + 20))
    }
    
    func heroBitMaskSet() {
        hero.physicsBody?.categoryBitMask = BitMasks.hero
        hero.physicsBody?.contactTestBitMask = BitMasks.ground | BitMasks.enemy | BitMasks.presentBox
        hero.physicsBody?.collisionBitMask = BitMasks.ground
    }
    
    
    // MARK: - Сніговик
    func addSnowMan() -> SKSpriteNode {
        snowMan = SKSpriteNode(texture: snowManTexture)
        
        let snowManAnimation = SKAction.animate(with: snowManTextureArray, timePerFrame: 0.2)
        let snowManIdle = SKAction.repeatForever(snowManAnimation)
        snowMan.run(snowManIdle)
        
        snowMan.size.height = snowMan.size.height / 7
        snowMan.size.width = snowMan.size.width / 7
        
        snowMan.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: snowMan.size.width, height: snowMan.size.height))
        
        snowMan.position.y = ground.position.y + (snowMan.size.height / 2) + 11
        snowMan.position.x = self.frame.size.width
        
        let moveSnowMan = SKAction.moveBy(x: -self.frame.size.width * 2, y: 0, duration: 6)
        let removeAction = SKAction.removeFromParent()
        let snowManMoveBg = SKAction.repeatForever(SKAction.sequence([moveSnowMan,removeAction]))
        snowMan.run(snowManMoveBg)
        
        snowMan.physicsBody?.isDynamic = false
        snowMan.physicsBody?.categoryBitMask = BitMasks.enemy
        snowMan.physicsBody?.contactTestBitMask = BitMasks.hero
        
        snowMan.physicsBody?.affectedByGravity = false
        
        snowMan.zPosition = 1
        
        return snowMan
    }
    
    
    // MARK: - Птичка
    
    func addBird() -> SKSpriteNode {
        bird = SKSpriteNode(texture: birdTexture)
        
        let birdAnimation = SKAction.animate(with: birdTextureArray, timePerFrame: 0.05)
        let birdFly = SKAction.repeatForever(birdAnimation)
        bird.run(birdFly)
        
        bird.size.height = bird.size.height / 12
        bird.size.width = bird.size.width / 12
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2)
        
        bird.position.y = ground.position.y + hero.size.height
        bird.position.x = self.frame.size.width + 300
        
        let moveBird = SKAction.moveBy(x: -self.frame.size.width * 2, y: 0, duration: 6)
        let removeAction = SKAction.removeFromParent()
        let birdMoveBg = SKAction.repeatForever(SKAction.sequence([moveBird,removeAction]))
        bird.run(birdMoveBg)
        
        bird.physicsBody?.isDynamic = false
        bird.physicsBody?.categoryBitMask = BitMasks.enemy
        bird.physicsBody?.contactTestBitMask = BitMasks.hero
        
        bird.physicsBody?.affectedByGravity = false
        
        bird.zPosition = 1
        
        return bird
    }
    
    // MARK: - Подарунок
    
    func addPresentBox() -> SKSpriteNode {
        presentBox = SKSpriteNode(texture: presentBoxTexture)
        
        presentBox.size.height = presentBox.size.height / 8
        presentBox.size.width = presentBox.size.width / 8
        
        presentBox.physicsBody = SKPhysicsBody(texture: presentBoxTexture!, size: presentBox.size)
        
        let maxPositionYForPresentBox = hero.frame.height / 1.5
        let minPositionYForPresentBox = ground.frame.maxY + (presentBox.frame.height / 2)
        
        presentBox.position.y = .random(in: minPositionYForPresentBox...maxPositionYForPresentBox)
        presentBox.position.x = self.frame.size.width + 300
        
        let movePresentBox = SKAction.moveBy(x: -self.frame.size.width * 2, y: 0, duration: 6)
        let removeAction = SKAction.removeFromParent()
        let presentBoxMoveBg = SKAction.repeatForever(SKAction.sequence([movePresentBox,removeAction]))
        presentBox.run(presentBoxMoveBg)
        
        presentBox.physicsBody?.isDynamic = true
        presentBox.physicsBody?.categoryBitMask = BitMasks.presentBox
        presentBox.physicsBody?.contactTestBitMask = BitMasks.hero
        
        presentBox.physicsBody?.affectedByGravity = false
        
        presentBox.zPosition = 1
        
        return presentBox
    }
    
    // MARK: - Додавання ворогів
    
    func createEnemy() {
        let createEnemy = SKAction.run {
            
            let randomIvent = Int.random(in: 1...3)
            switch randomIvent {
            case 1:
                let snowMan = self.addSnowMan()
                self.addChild(snowMan)
            case 2:
                let bird = self.addBird()
                self.addChild(bird)
            case 3:
                let presentBox = self.addPresentBox()
                self.addChild(presentBox)
            default:
                print("error")
            }
        }
        
        let enemyCreationDelay = SKAction.wait(forDuration: .random(in: 2...3), withRange: 1)
        let enemySequenceAction = SKAction.sequence([createEnemy,enemyCreationDelay])
        let enemyRunAction = SKAction.repeatForever(enemySequenceAction)
        
        run(enemyRunAction)
    }
    
    
    // MARK: - Рахунок, пауза та життя
    func setLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: self.frame.width - 20, y: self.frame.height - 40)
        addChild(scoreLabel)
    }
    
    func setPause() {
        settingButton = SKSpriteNode(imageNamed: "pause-button")
        settingButton.size.height = scoreLabel.frame.height
        settingButton.size.width = settingButton.size.height
        settingButton.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        settingButton.position = CGPoint(x: 20, y: self.frame.height - 40)
        settingButton.zPosition = 99
        settingButton.name = "pause"
        addChild(settingButton)
    }
    
    func setLife() {
        
        life1 = SKSpriteNode(texture: lifeHeart, size: settingButton.size)
        life2 = SKSpriteNode(texture: lifeHeart, size: settingButton.size)
        life3 = SKSpriteNode(texture: lifeHeart, size: settingButton.size)
        
        let lifes = [life1, life2, life3]
        for (index, life) in lifes.enumerated() {
            life.position = CGPoint(x: self.frame.midX - CGFloat(index + 1) * (life.size.width + 5), y: self.frame.height - 40)
            life.zPosition = 99
            life.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            addChild(life)
        }
    }

    
    
    // MARK: - Сніг
    func createGeneralSnow() {
        let generalSnow = SKEmitterNode(fileNamed: "GeneralSnow.sks")!
        generalSnowObjeckt.zPosition = 2
        generalSnowObjeckt.addChild(generalSnow)
        generalSnow.position = CGPoint(x: self.frame.midX, y: self.frame.maxY)
        generalSnow.advanceSimulationTime(50)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "pause" {
            let tranzition = SKTransition.doorsOpenHorizontal(withDuration: 1.0)
            let pauseScene = PauseScene(size: (self.view?.frame.size)!)
            pauseScene.scaleMode = .aspectFill
            sceneManager.gameScene = self
            self.scene?.isPaused = true
            self.scene?.view?.presentScene(pauseScene, transition: tranzition)
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        var enotherBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask == BitMasks.hero {
            enotherBody = contact.bodyB
        } else {
            enotherBody = contact.bodyA
        }
        
        switch enotherBody.categoryBitMask {
        case BitMasks.ground:
            onGround = true
            print(onGround)
        case BitMasks.enemy:
            print("ouch -1 life points")
            let pulsedRed = SKAction.sequence([
                SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.2),
                SKAction.wait(forDuration: 0.1),
                SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.15)
            ])
            hero.run(pulsedRed)
            lives -= 1
        case BitMasks.presentBox:
            if enotherBody.node?.parent != nil {
                enotherBody.node?.removeFromParent()
                score += 1
                print("+1 score")
            }
            
        default:
            print("contact unknown")
            
        }
        
        if lives == 0 {
            
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
        var enotherBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask == BitMasks.hero {
            enotherBody = contact.bodyB
        } else {
            enotherBody = contact.bodyA
        }
        
        if enotherBody.categoryBitMask == BitMasks.ground {
            onGround = false
            print(onGround)
        }
    }
}

