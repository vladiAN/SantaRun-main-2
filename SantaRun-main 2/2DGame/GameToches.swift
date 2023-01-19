//
//  GameToches.swift
//  2DGame
//
//  Created by Андрушок on 06.01.2023.
//

import Foundation
import SpriteKit

extension GameScene {
    
    func setupHeroForSwipe() {
        hero.physicsBody?.velocity = CGVector.zero
        hero.physicsBody?.allowsRotation = false
        hero.physicsBody?.restitution = 0.0
    }
    
    @objc func swipeUp() {
        
        if onGround == true {
            setupHeroForSwipe()
            hero.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 200))
            
            let heroJumpTextureArray = SKAction.animate(with: heroJumpTextureArray, timePerFrame: 0.06)
            hero.run(heroJumpTextureArray)
        }
    }
    
    @objc func swipeDown() {
        setupHeroForSwipe()
        hero.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Slide (1)"), size: hero.size)
        
        heroBitMaskSet()
        
        let heroJumpTextureArray = SKAction.animate(with: heroSlideTextureArray, timePerFrame: 0.1)
        let returnToRunPhysicsBody = SKAction.wait(forDuration: 0)
        hero.run(SKAction.sequence([
        heroJumpTextureArray,
        returnToRunPhysicsBody,
        SKAction.run({ [self] in
            self.hero.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Run (2)"), size: hero.size)
            heroBitMaskSet()
        })
        ]))
        
        
    }
    
}
