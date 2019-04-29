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
    var mainCharacter: SKSpriteNode = SKSpriteNode(imageNamed: "maincharacter.png")
    var arrow: SKSpriteNode = SKSpriteNode(imageNamed: "Arrow.png")
    var monster: SKSpriteNode = SKSpriteNode(imageNamed: "monster.png")
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
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func sceneDidLoad() {

        self.lastUpdateTime = 0
        
        startNewGame()
        
        startLabel = SKLabelNode(fontNamed: "Chalkduster")
        startLabel.text = "Start New Game"
        startLabel.position = CGPoint(x: 80, y:700)
        addChild(startLabel)
        
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
    
    func startNewGame() {
        for i in stride(from: 32, to: 1024, by: 64){
            for k in stride(from: 0, to: 620, by: 64) {
                createWall(i: i, k: k)
            }
        }
        createHealth()
        let size = CGSize(width: 64, height: 64)
        mainCharacter.name = "mainCharacter"
        mainCharacter.physicsBody = SKPhysicsBody(rectangleOf: size)
        mainCharacter.physicsBody!.isDynamic = false
        mainCharacter.position = CGPoint(x: mainCharacterX, y: mainCharacterY)
        addChild(mainCharacter)
        
        timer = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(spawnMonster), userInfo: nil, repeats: true)
        moveTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkMonsterY), userInfo: nil, repeats: true)
    }
    
    @objc func spawnMonster() {
        let monster: SKSpriteNode = SKSpriteNode(imageNamed: "monster.png")
        let size = CGSize(width: 64, height: 64)
        monster.name = "monster" + String(totalMonsters)
        monster.physicsBody = SKPhysicsBody(rectangleOf: size)
        monster.physicsBody!.isDynamic = false
        monster.position = CGPoint(x: 32 + 64 * Int.random(in: 0...15), y: 576)
        addChild(monster)
//        let move = SKAction.moveTo(y:  CGFloat(self.monsterY), duration: 1)
        let move = SKAction.moveBy(x: 0, y: -64, duration: 2)
        let moveForever = SKAction.repeatForever(move)
        monster.run(moveForever)
    }
    
    func moveMonster() {
        if monsterY >= 64 {
            monsterY = monsterY - 64
        } else {
            if health == 3 {
                health = health - 1
                monster.removeFromParent()
                monsterY = 576
            } else if health == 2 {
                health = health - 1
                monster.removeFromParent()
                monsterY = 576
            } else {
                
            }
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
            heart.name = "heart" + String(i)
            heart.physicsBody = SKPhysicsBody(rectangleOf: size)
            heart.physicsBody!.isDynamic = false
            heart.position = CGPoint(x: l, y: 636)
            addChild(heart)
        }
    }
    @objc func checkMonsterY() {
        if monsterY < 64 {
            if health == 3 {
                health = health - 1
                monster.removeFromParent()
            } else if health == 2 {
                health = health - 1
                monster.removeFromParent()
            } else {
                exit(0)
            }
        }
    }
    
    
    func createArrow() {
        let size = CGSize(width: 64, height: 64)
        arrow.name = "arrow"
        arrow.physicsBody = SKPhysicsBody(rectangleOf: size)
        arrow.physicsBody!.contactTestBitMask = arrow.physicsBody!.collisionBitMask
        arrow.physicsBody!.isDynamic = false
        arrow.position = CGPoint(x: mainCharacterX, y: mainCharacterY + 64)
        arrowAlive = true
        addChild(arrow)
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
        if let touch = touches.first {
            let position = touch.location(in: self)
            if position.x <= 341.333333333 && !(mainCharacterX <= 64) {
                mainCharacterX = mainCharacterX - 64
                mainCharacter.run(SKAction.moveTo(x: CGFloat(mainCharacterX), duration: 0.5))
            } else if position.x > 341.333333333 && position.x <= 682.6666666666 {
                if arrowAlive == false {
                    createArrow()
                        repeat {
                            arrowY = arrowY + 64
                            arrow.run(SKAction.moveTo(y: CGFloat(arrowY), duration: 1/6))
                        } while (arrowY < 576)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                            self.arrow.removeFromParent()
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
