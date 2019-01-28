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
    
    // MARK: - Fields
    
    var bricks = [SKSpriteNode]()
    var brickSize = CGSize.zero
    var scrollSpeed: CGFloat = 5.0
    var lastUpdateTime: TimeInterval?
    let skater = Skater(imageNamed: "skater")
    
    
    // MARK: - Override functions
    
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
        
        var elapsedTime: TimeInterval = 0.0
        if let lastTimeStamp = lastUpdateTime {
            elapsedTime = currentTime - lastTimeStamp
        }

        lastUpdateTime = currentTime

        let expectedElapsedTime: TimeInterval = 1.0 / 60.0

        let scrollAdjastment = CGFloat(elapsedTime / expectedElapsedTime)
        let currentScrollAmount = scrollSpeed * scrollAdjastment

        updateBrick(withScrollAmount: currentScrollAmount)
    }
    
    
    // MARK: - Primary functions
    
    /// Primary position of the skater
    private func resetSkater() {
        let skaterX = frame.midX / 2.0
        let skaterY = skater.frame.height / 2.0 + 64.0
        skater.position = CGPoint(x: skaterX, y: skaterY)
        skater.zPosition = 10
        skater.minimumY = skaterY
    }
    
    private func spawnBrick(at position: CGPoint) -> SKSpriteNode {
        // Create brick object
        let brick = SKSpriteNode(imageNamed: "sidewalk")
        brick.position = position
        brick.zPosition = 8
        addChild(brick)
        
        // Update property by real size
        brickSize = brick.size
        bricks.append(brick)
        
        return brick
    }
    
    private func updateBrick(withScrollAmount currentScrollAmount: CGFloat) {
        var farthestRightBrickX: CGFloat = 0.0
        
        for brick in bricks {
            let newX = brick.position.x - currentScrollAmount
            
            // If brick is out of the screen
            if newX < -brickSize.width {
                
                brick.removeFromParent()
                if let brickIndex = bricks.index(of: brick) {
                    bricks.remove(at: brickIndex)
                }
                
            } else {
                brick.position = CGPoint(x: newX, y: brick.position.y)
            }
            
            if brick.position.x > farthestRightBrickX {
                farthestRightBrickX = brick.position.x
            }
        }
        
        while farthestRightBrickX < frame.width {
            var brickX = farthestRightBrickX + brickSize.width + 1.0
            let brickY = brickSize.height / 2.0
            
            let randomNumber = arc4random_uniform(99)
            
            // 5% chance of gap between bricks
            if randomNumber < 5 {
                let gap = 20.0 * scrollSpeed
                brickX += gap
            }
            
            let newBrick = spawnBrick(at: CGPoint(x: brickX, y: brickY))
            farthestRightBrickX = newBrick.position.x
        }
    }
}
