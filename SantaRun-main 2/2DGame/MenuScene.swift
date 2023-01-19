//
//  MenuScene.swift
//  2DGame
//
//  Created by Алина Андрушок on 19.01.2023.
//

import SpriteKit

class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.3, alpha: 1.0)
        let texture = SKTexture(imageNamed: "play-button")
        let button = SKSpriteNode(texture: texture)
        button.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        button.size.height = button.size.height / 6
        button.size.width = button.size.width / 6
        button.name = "runButton"
        self.addChild(button)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "runButton" {
            let tranzition = SKTransition.crossFade(withDuration: 1.0)
            let gameScene = GameScene(size: (self.view?.frame.size)!)
            gameScene.scaleMode = .aspectFill
            self.scene?.view?.presentScene(gameScene, transition: tranzition)
        }
    }
}