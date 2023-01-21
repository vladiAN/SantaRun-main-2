//
//  MenuScene.swift
//  2DGame
//
//  Created by Алина Андрушок on 19.01.2023.
//

import SpriteKit

class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = SKColor(red: 0.61, green: 0.88, blue: 1.00, alpha: 1.00)
        
        let logo = SKSpriteNode(imageNamed: "Logo1")
        
        logo.size.height = logo.size.height / 2
        logo.size.width = logo.size.width / 2
        
        logo.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - (logo.frame.height / 2) - 16 )
        self.addChild(logo)
        
        let titles = ["play", "options", "records"]
        
        for (index, title) in titles.enumerated() {
            let button = ButtonNode(title: title, backgroundName: "Button")
            button.position = CGPoint(x: self.frame.midX, y: logo.frame.minY - 50 - CGFloat(75 * index))
            button.name = title
            button.label.name = title
            addChild(button)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = self.atPoint(location)
        
        if node.name == "play" {
            let tranzition = SKTransition.crossFade(withDuration: 1.0)
            let gameScene = GameScene(size: (self.view?.frame.size)!)
            gameScene.scaleMode = .aspectFill
            self.scene?.view?.presentScene(gameScene, transition: tranzition)
        }
    }
}

class ButtonNode: SKSpriteNode {
    let label: SKLabelNode = {
        let label = SKLabelNode(text: "text")
        label.fontColor = UIColor(red: 0.07, green: 0.45, blue: 0.87, alpha: 1.00)
        label.fontName = "Chalkduster"
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.zPosition = 2
        return label
    }()
    
    init(title: String, backgroundName: String) {
        let texture = SKTexture(imageNamed: backgroundName)
        super.init(texture: texture, color: .clear, size: CGSize(width: texture.size().width / 2, height: texture.size().height / 2))
        label.text = title.uppercased()
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
