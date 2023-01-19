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
            hero.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 300))
            
            let heroJumpTextureArray = SKAction.animate(with: heroJumpTextureArray, timePerFrame: 0.06)
            hero.run(heroJumpTextureArray)
        }
    }
    
    @objc func swipeDown() {
        setupHeroForSwipe()
        hero.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: hero.size.width - 120, height: hero.size.height - 80),
                                         center: CGPoint(x: -40, y: -30))
        
        heroBitMaskSet()
        
        let heroJumpTextureArray = SKAction.animate(with: heroSlideTextureArray, timePerFrame: 0.1)
        let returnToRunPhysicsBody = SKAction.wait(forDuration: 0)
        hero.run(SKAction.sequence([
            heroJumpTextureArray,
            returnToRunPhysicsBody,
            SKAction.run({ [self] in
                self.hero.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: hero.size.width - 160, height: hero.size.height - 20),
                                                      center: CGPoint(x: -20, y: 5))
                heroBitMaskSet()
            })
        ]))
    }
    
}
