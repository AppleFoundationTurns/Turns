//
//  MovementScene.swift
//  Turns-v1
//
//  Created by Giuseppe Damiata on 30/06/24.
//

import SpriteKit

class MovementScene: SKScene, SKPhysicsContactDelegate {
    
    var character = SKSpriteNode(imageNamed: "idle1")
    
    var background = SKSpriteNode()
    var platform = SKSpriteNode()
    var leftSide = SKSpriteNode()
    var rightSide = SKSpriteNode()
    var jumpSide = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        //let xSize = self.frame.size.width
        //let ySize = self.frame.size.height
        
        // --- Add physics to scene, no friction, no out of frame ---
        let sceneBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = sceneBody
        sceneBody.friction = 0
        physicsWorld.contactDelegate = self
        
        // --- Hero initialization ---
        let characterScale: CGFloat = 2.0
        initSpriteNode(sprite: character,
            name: "Hero",
            scale: characterScale,
            physicsBody: SKPhysicsBody(
                rectangleOf: CGSize(
                    width: character.size.width * characterScale,
                    height: character.size.height * characterScale)),
            affectedByGravity: true,
            categoryBitMask: 0b01,
            collisionsBitMask: 0b10,
            contactTestBitMask: 0b10)
        // --- Idle animation ---
        idleAction(sprite: character)
        self.addChild(character)
        
        // --- Background initialization ---
        background = childNode(withName: "background") as! SKSpriteNode
        //background.color = .clear
        
        // --- Platform initialization ---
        platform = childNode(withName: "platform") as! SKSpriteNode
        let platformSize: CGSize = CGSize(width: 1334, height: 200)
        initSpriteNode(sprite: platform,
            name: "platform",
            position: platform.position,
            physicsBody: SKPhysicsBody(
                rectangleOf: platformSize),
            categoryBitMask: 0b10)
        
        platform.size = platformSize
        platform.physicsBody?.friction = 0
        
        // --- Buttons initialization ---
        leftSide = childNode(withName: "leftSide") as! SKSpriteNode
        rightSide = childNode(withName: "rightSide") as! SKSpriteNode
        jumpSide = childNode(withName: "jumpSide") as! SKSpriteNode
        
        leftSide.color = .clear
        rightSide.color = .clear
        jumpSide.color = .clear
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            let node = self.atPoint(touchLocation)
            if node.name == "leftSide" {
                //character.physicsBody?.applyForce(CGVector(dx: -100, dy: 1))
                character.physicsBody?.velocity = CGVector(dx: -100, dy: 0)
            } else if node.name == "rightSide" {
                character.physicsBody?.velocity = CGVector(dx: 100, dy: 1)
            } else if node.name == "jumpSide" {
                character.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for touch in touches {
        //let touchLocation = touch.location(in: self)
        //let node = self.atPoint(touchLocation)
        character.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        //}
    }
    
    func initSpriteNode(sprite: SKSpriteNode, name: String, position: CGPoint = CGPoint(x: 0, y: 0), scale: CGFloat = 1.0, physicsBody: SKPhysicsBody? = nil, isDynamic: Bool = true, allowsRotation: Bool = false, mass: CGFloat = 0.1, affectedByGravity: Bool = false, categoryBitMask: UInt32 = 0b0, collisionsBitMask: UInt32 = 0b0, contactTestBitMask: UInt32 = 0b0)  {
        sprite.name = name
        sprite.position = position
        sprite.setScale(scale)
        sprite.physicsBody = physicsBody
        sprite.physicsBody?.isDynamic = isDynamic
        sprite.physicsBody?.allowsRotation = allowsRotation
        sprite.physicsBody?.mass = mass
        sprite.physicsBody?.affectedByGravity = affectedByGravity
        sprite.physicsBody?.categoryBitMask = categoryBitMask
        sprite.physicsBody?.collisionBitMask = collisionsBitMask
        sprite.physicsBody?.contactTestBitMask = contactTestBitMask
    }
    
    func idleAction(sprite: SKSpriteNode) {
        let s1 = SKTexture(imageNamed: "idle1")
        let s2 = SKTexture(imageNamed: "idle2")
        let s3 = SKTexture(imageNamed: "idle3")
        let s4 = SKTexture(imageNamed: "idle4")
        let s5 = SKTexture(imageNamed: "idle5")
        let s6 = SKTexture(imageNamed: "idle6")
        let s7 = SKTexture(imageNamed: "idle7")
        let s8 = SKTexture(imageNamed: "idle8")
        let s9 = SKTexture(imageNamed: "idle9")
        let s10 = SKTexture(imageNamed: "idle10")
        let s11 = SKTexture(imageNamed: "idle11")
        let s12 = SKTexture(imageNamed: "idle12")
        let s13 = SKTexture(imageNamed: "idle13")
        let s14 = SKTexture(imageNamed: "idle14")
        let idleAction = SKAction.animate(with: [s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14], timePerFrame: 0.1)
        sprite.run(SKAction.repeatForever(idleAction))
    }
}
