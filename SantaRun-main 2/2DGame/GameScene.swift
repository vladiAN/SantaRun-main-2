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
}

class GameScene: SKScene {

    var bgTexture: SKTexture!
    var heroTexture: SKTexture!
    
    var bg = SKSpriteNode()
    var hero = SKSpriteNode()
    var ground = SKSpriteNode()
    
    var bgObjeckt = SKNode()
    var heroObjeckt = SKNode()
    var groundObjeckt = SKNode()
    var generalSnowObjeckt = SKNode()
    
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

    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        bgTexture = SKTexture(imageNamed: "bg winter")
        heroTexture = SKTexture(imageNamed: "Run (1)")
        
        createObjects()
        createGame()
        
    }
    
    func createObjects() {
        
        self.addChild(bgObjeckt)
        self.addChild(groundObjeckt)
        self.addChild(heroObjeckt)
        self.addChild(generalSnowObjeckt)
          
    }
    
    func createGame() {
        
        createBg()
        createGround()
        createHero()
        createGeneralSnow()
        
        swipe()
        
    }

    func createBg() {
        bgTexture = SKTexture(imageNamed: "bg winter")
        
        let moveBg = SKAction.moveBy(x: -bgTexture.size().width, y: 0, duration: 5)
        let replaseBg = SKAction.moveBy(x: bgTexture.size().width, y: 0, duration: 0)
        let moveBrRepeat = SKAction.repeatForever(SKAction.sequence([moveBg, replaseBg]))
        
        for i in 0..<3 {
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width * CGFloat(i), y: 50)
            bg.run(moveBrRepeat)
            bg.zPosition = -10
            
            bgObjeckt.addChild(bg)
            
        }
    }
    
    func createGround() {
        ground = SKSpriteNode()
        ground.position.y = self.position.y - 150
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 20))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = BitMasks.ground
        ground.physicsBody?.contactTestBitMask = BitMasks.hero
        ground.physicsBody?.restitution = 0.0
        ground.zPosition = 1
        
        groundObjeckt.addChild(ground)
    }
    
    func addHero(heroNode: SKSpriteNode, atPosition position: CGPoint) {
        hero = SKSpriteNode(texture: heroTexture)
        
        let heroRunAnimation = SKAction.animate(with: heroRunTextureArray, timePerFrame: 0.1)
        let heroRun = SKAction.repeatForever(heroRunAnimation)
        hero.run(heroRun)
        
        hero.position = position
        hero.size.height = hero.size.height / 4
        hero.size.width = hero.size.width / 4
        
        hero.physicsBody = SKPhysicsBody(texture: hero.texture!, size: hero.size)
        
        hero.physicsBody?.categoryBitMask = BitMasks.hero
        hero.physicsBody?.contactTestBitMask = BitMasks.ground
        hero.physicsBody?.collisionBitMask = BitMasks.ground
        
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.allowsRotation = false
        hero.physicsBody?.restitution = 0.0
        hero.zPosition = 1
        
        heroObjeckt.addChild(hero)
    }
    
    func createHero() {
        addHero(heroNode: hero, atPosition: CGPoint(x: self.frame.minX + 120, y: 0))
    }
    
    func swipe() {
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp))
        swipeUp.direction = .up
        view?.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown))
        swipeDown.direction = .down
        view?.addGestureRecognizer(swipeDown)
        
    }
    
    func createGeneralSnow() {
        let generalSnow = SKEmitterNode(fileNamed: "GeneralSnow.sks")!
        generalSnowObjeckt.zPosition = 2
        generalSnowObjeckt.addChild(generalSnow)
        generalSnow.position = CGPoint(x: self.frame.midX, y: self.frame.maxY)
        generalSnow.advanceSimulationTime(50)
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        var groundBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask == BitMasks.hero {
            groundBody = contact.bodyB
        } else {
            groundBody = contact.bodyA
        }
        
        if groundBody.categoryBitMask == BitMasks.ground {
            onGround = true
            print(onGround)
        }
    }

    func didEnd(_ contact: SKPhysicsContact) {

        var groundBody: SKPhysicsBody

                if contact.bodyA.categoryBitMask == BitMasks.hero {
                    groundBody = contact.bodyB
                } else {
                    groundBody = contact.bodyA
                }

        if groundBody.categoryBitMask == BitMasks.ground {
            onGround = false
            print(onGround)
        }
    }
}

