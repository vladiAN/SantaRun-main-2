//
//  GameViewController.swift
//  2DGame
//
//  Created by Андрушок on 05.01.2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
         let view = self.view as! SKView
            // Load the SKScene from 'GameScene.sks'
            let scene = MenuScene(size: self.view.frame.size)
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        
    }

}
