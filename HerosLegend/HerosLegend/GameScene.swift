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

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var health = 3
    var score = 0
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var mainCharacter: SKSpriteNode = SKSpriteNode(imageNamed: "maincharacter.png")
    //var arrow: SKSpriteNode = SKSpriteNode(imageNamed: "Arrow.png")
    var monster: SKSpriteNode!
    var mainCharacterX: Int = 480
    var mainCharacterY: Int = 192
    var arrowY: Int = 192
    var monsterY: Int = 576
    var arrowAlive = false
    var timer: Timer!
    var moveTimer: Timer!
    var totalMonsters = 0
    var scoreLabel: SKLabelNode!
    var startLabel: SKLabelNode!
    var heart1: SKSpriteNode!
    var heart2: SKSpriteNode!
    var heart3: SKSpriteNode!
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func sceneDidLoad() {
        
        
//        self.lastUpdateTime = 0
//
//        startNewGame()
//
//        startLabel = SKLabelNode(fontNamed: "Chalkduster")
//        startLabel.text = "Start New Game"
//        startLabel.position = CGPoint(x: 762, y:0)
//        addChild(startLabel)
//
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
    }
    
    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsWorld.contactDelegate = self
        
        self.lastUpdateTime = 0
        
        startNewGame()
        
        startLabel = SKLabelNode(fontNamed: "Chalkduster")
        startLabel.text = "Start New Game"
        startLabel.position = CGPoint(x: 762, y:0)
        addChild(startLabel)
    }
    
    func startNewGame() {
        for i in stride(from: 32, to: 1024, by: 64){
            for k in stride(from: 0, to: 620, by: 64) {
                createWall(i: i, k: k)
            }
        }
        createHealth()
        let size = CGSize(width: 64, height: 64)
        mainCharacter.name = "mainCharacter"
        mainCharacter.physicsBody = SKPhysicsBody(rectangleOf: mainCharacter.size) //size)
        mainCharacter.physicsBody!.contactTestBitMask = mainCharacter.physicsBody!.collisionBitMask
        mainCharacter.physicsBody!.isDynamic = false
        mainCharacter.position = CGPoint(x: mainCharacterX, y: mainCharacterY)
        addChild(mainCharacter)
        
//        let box = SKSpriteNode(imageNamed: "monster.png")
//        box.physicsBody = SKPhysicsBody(rectangleOf: size)
//        box.physicsBody!.isDynamic = false
//        box.position = CGPoint(x:416 , y:192)
//        box.name = "box"
//        addChild(box)
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(spawnMonster), userInfo: nil, repeats: true)
//        moveTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(checkMonsterY), userInfo: nil, repeats: true)
    }
    
    @objc func spawnMonster() {
        
        monster = SKSpriteNode(imageNamed: "monster.png")
        let size = CGSize(width: 64, height: 64)
        monster.name = "monster"
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size)//size)
        monster.physicsBody!.contactTestBitMask = monster.physicsBody!.collisionBitMask
        monster.physicsBody!.isDynamic = true
        monster.position = CGPoint(x: 32 + 64 * Int.random(in: 0...15), y: 576)
        addChild(monster)
//        let move = SKAction.moveTo(y:  CGFloat(self.monsterY), duration: 1)
        let move = SKAction.moveBy(x: 0, y: -64, duration: 2)
        let moveForever = SKAction.repeatForever(move)
        monster.run(moveForever)
    }
    
    func createWall(i: Int, k: Int) {
        let wall = SKSpriteNode(imageNamed: "Floor-Tile2.png")
        let size = CGSize(width: 64, height: 64)
//        wall.physicsBody = SKPhysicsBody(rectangleOf: size)
//        wall.physicsBody!.isDynamic = false
        wall.position = CGPoint(x: i, y: k)
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
            if i == 1 {
                let heart1 = SKSpriteNode(imageNamed: "Heart.png")
                heart1.name = "heart" + String(i)
                heart1.physicsBody = SKPhysicsBody(rectangleOf: size)
                heart1.physicsBody!.isDynamic = false
                heart1.position = CGPoint(x: l, y: 636)
                addChild(heart1)
            } else if i == 2 {
                let heart2 = SKSpriteNode(imageNamed: "Heart.png")
                heart2.name = "heart" + String(i)
                heart2.physicsBody = SKPhysicsBody(rectangleOf: size)
                heart2.physicsBody!.isDynamic = false
                heart2.position = CGPoint(x: l, y: 636)
                addChild(heart2)
            } else {
                let heart3 = SKSpriteNode(imageNamed: "Heart.png")
                heart3.name = "heart" + String(i)
                heart3.physicsBody = SKPhysicsBody(rectangleOf: size)
                heart3.physicsBody!.isDynamic = false
                heart3.position = CGPoint(x: l, y: 636)
                addChild(heart3)
            }
        }
    }
//    @objc func checkMonsterY() {
//        print("Check")
//            if monster.position.y <= 64 {
//                if health == 3 {
//                    health = health - 1
//                    heart3.removeFromParent()
//                    monster.removeFromParent()
//                    monsterY = 576
//                    print("runs")
//                } else if health == 2 {
//                    health = health - 1
//                    heart2.removeFromParent()
//                    monster.removeFromParent()
//                    monsterY = 576
//                } else {
//                    heart1.removeFromParent()
//            }
//        } else {
//            print("UNCLE ANDROSS!!!")
//            }
//    }
    
    
//    func createArrow() {
//        let size = CGSize(width: 64, height: 64)
//        arrow.name = "arrow"
//        arrow.physicsBody = SKPhysicsBody(rectangleOf: arrow.size)//size)
//        arrow.physicsBody!.contactTestBitMask = arrow.physicsBody!.collisionBitMask
//        arrow.physicsBody!.isDynamic = false
//        arrow.position = CGPoint(x: mainCharacterX, y: mainCharacterY + 64)
//        arrowAlive = true
//        addChild(arrow)
//        print("pew!")
//    }
    
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("in didBegin")
        if contact.bodyA.node?.name == "monster" {
            collisionBetween(monster: contact.bodyA.node!, object: contact.bodyB.node!)
        } else if contact.bodyB.node?.name == "monster" {
            collisionBetween(monster: contact.bodyB.node!, object: contact.bodyA.node!)
        } //else if contact.bodyA.node?.name != "arrow" && contact.bodyB.node?.name != "name" && (contact.bodyB.node?.name == "mainCharacter" || contact.bodyA.node?.name == "mainCharacter") {
            
        //}
    }
    
    func collisionBetween(monster: SKNode, object: SKNode) {
        print("in Collision")
        if object.name == "arrow" && monster.name == "monster" {
            score += 100
            monster.removeFromParent()
            object.removeFromParent()
//            arrowAlive = false
            print("Runs if collision")
        } else if (monster.name == "monster" && object.name == "mainCharacter") || (monster.name == "monster" && object.name == "mainCharacter") {
            monster.removeFromParent()
             print("Runs collision")
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
        if let touch = touches.first {
            let position = touch.location(in: self)
            if position.x <= 341.333333333 && !(mainCharacterX <= 64) {
                mainCharacterX = mainCharacterX - 64
                mainCharacter.run(SKAction.moveTo(x: CGFloat(mainCharacterX), duration: 0.5))
            } else if position.x > 341.333333333 && position.x <= 682.6666666666 {
                if arrowAlive == false {
                    let arrow = SKSpriteNode(imageNamed: "Arrow.png")
                    let size = CGSize(width: 64, height: 64)
                    arrow.name = "arrow"
                    arrow.physicsBody = SKPhysicsBody(rectangleOf: arrow.size)//size)
                    arrow.physicsBody!.contactTestBitMask = arrow.physicsBody!.collisionBitMask
                    arrow.physicsBody!.isDynamic = false
                    arrow.position = CGPoint(x: mainCharacterX, y: mainCharacterY + 64)
                    arrowAlive = true
                    addChild(arrow)
                    print("pew!")
                        repeat {
                            arrowY = arrowY + 64
                            arrow.run(SKAction.moveTo(y: CGFloat(arrowY), duration: 1/6))
                        } while (arrowY < 576)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            arrow.removeFromParent()
                            self.arrowY = self.mainCharacterY + 64
                            self.arrowAlive = false
                        })
                }
            } else if position.x > 682.666666666666 && !(mainCharacterX >= 960) {
                mainCharacterX = mainCharacterX + 64
                mainCharacter.run(SKAction.moveTo(x: CGFloat(mainCharacterX), duration: 0.5))
            }
        }
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
