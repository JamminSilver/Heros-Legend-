//
//  GameScene.swift
//  HerosLegend
//
//  Created by Snake on 4/15/19.
//  Copyright © 2019 Snake. All rights reserved.
//

import SpriteKit
import GameplayKit

var total = 0

class GameScene: SKScene {
    
    var health = 3
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        for i in stride(from: 32, to: 1024, by: 64){
            for k in stride(from: 0, to: 620, by: 64) {
                createWall(i: i, k: k)
            }
        }
        createHealth()
        print(total)
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    func createWall(i: Int, k: Int) {
        let wall = SKSpriteNode(imageNamed: "Floor-Tile2.png")
        let size = CGSize(width: 64, height: 64)
        wall.physicsBody = SKPhysicsBody(rectangleOf: size)
        wall.physicsBody!.isDynamic = false
        wall.position = CGPoint(x: i, y: k)
        print("X:" + String(i) + " Y:" + String(k))
        total = total + 1
        addChild(wall)
    }
    func createHealth() {
        var box: SKSpriteNode = SKSpriteNode(imageNamed: "Letter-H.png")
        var l = 0
        for i in 1...6 {
            switch i {
                
            case 1:
                box = SKSpriteNode(imageNamed: "Letter-H.png")
                
            case 2:
                box = SKSpriteNode(imageNamed: "Letter-E.png")
                
            case 3:
                box = SKSpriteNode(imageNamed: "Letter-A.png")
                
            case 4:
                box = SKSpriteNode(imageNamed: "Letter-L.png")
                
            case 5:
                box = SKSpriteNode(imageNamed: "Letter-T.png")
                
            case 6:
                box = SKSpriteNode(imageNamed: "Letter-H.png")
            
            default:
                box = SKSpriteNode(imageNamed: "Letter-A.png")
                
            }
            switch i {
                
            case 1:
                l = 32
                
            case 2:
                l = 96
                
            case 3:
                l = 160
                
            case 4:
                l = 224
                
            case 5:
                l = 288
                
            case 6:
                l = 352
                
            default:
                l = 0
                
            }
        let size = CGSize(width: 64, height: 64)
        box.physicsBody = SKPhysicsBody(rectangleOf: size)
        box.physicsBody!.isDynamic = false
        box.position = CGPoint(x: l, y: 636)
        addChild(box)
        }
        for i in 1...3 {
            var l = 0
            let heart = SKSpriteNode(imageNamed: "Heart.png")
            let size = CGSize(width: 64, height: 64)
            switch i {
                
            case 1:
                l = 480
                
            case 2:
                l = 544
                
            case 3:
                l = 608
                
            default:
                l = 0
                
            }
            heart.physicsBody = SKPhysicsBody(rectangleOf: size)
            heart.physicsBody!.isDynamic = false
            heart.position = CGPoint(x: l, y: 636)
            addChild(heart)
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
