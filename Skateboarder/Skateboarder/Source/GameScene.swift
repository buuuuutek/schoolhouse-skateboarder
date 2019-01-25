//
//  GameScene.swift
//  Skateboarder
//
//  Created by Волнухин Виктор on 25/01/2019.
//  Copyright © 2019 Волнухин Виктор. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let skater = Skater(imageNamed: "skater")
    
    override func didMove(to view: SKView) {
        anchorPoint = CGPoint.zero
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(background)
        
        resetSkater()
        addChild(skater)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    /// Primary position of the skater
    private func resetSkater() {
        let skaterX = frame.midX / 2.0
        let skaterY = skater.frame.height / 2.0 + 64.0
        skater.position = CGPoint(x: skaterX, y: skaterY)
        skater.zPosition = 10
        skater.minimumY = skaterY
    }
}
