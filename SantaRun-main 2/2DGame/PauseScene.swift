//
//  PauseScene.swift
//  2DGame
//
//  Created by Алина Андрушок on 21.01.2023.
//

import SpriteKit

class PauseScene: SKScene {

    override func didMove(to view: SKView) {
        
        let bg = SKSpriteNode(imageNamed: "bg winter")
        bg.size.height = self.frame.height
        bg.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        bg.zPosition = -99
        addChild(bg)
        
        let generalSnow = SKEmitterNode(fileNamed: "GeneralSnow.sks")!
        generalSnow.position = CGPoint(x: self.frame.midX, y: self.frame.maxY)
        generalSnow.advanceSimulationTime(50)
        generalSnow.zPosition = 1
        addChild(generalSnow)
        
        let header = ButtonNode(title: "pause", backgroundName: "headerPause")
        
        header.size.height = header.size.height / 1.5
        header.size.width = header.size.width / 1.1
        
        header.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - (header.frame.height / 2) - 16 )
        self.addChild(header)
        
        let titles = ["restart", "options", "resume"]
        
        for (index, title) in titles.enumerated() {
            let button = ButtonNode(title: title, backgroundName: "Button")
            button.position = CGPoint(x: self.frame.midX, y: header.frame.minY - 75 - CGFloat(75 * index))
            button.name = title
            button.label.name = title
            addChild(button)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "restart" {
            let tranzition = SKTransition.crossFade(withDuration: 1.0)
            let gameScene = GameScene(size: (self.view?.frame.size)!)
            gameScene.scaleMode = .aspectFill
            self.scene?.view?.presentScene(gameScene, transition: tranzition)
        }
    }
}
