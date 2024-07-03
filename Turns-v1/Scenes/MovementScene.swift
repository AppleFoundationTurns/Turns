//
//  MovementScene.swift
//  Turns-v1
//
//  Created by Giuseppe Damiata on 30/06/24.
//

import SpriteKit

class MovementScene: SKScene, SKPhysicsContactDelegate {
    
    var character = SKSpriteNode()
    
    var background = SKSpriteNode()
    var platform = SKSpriteNode()
    var leftSide = SKSpriteNode()
    var rightSide = SKSpriteNode()
    var jumpSide = SKSpriteNode()
    
    var isTouchPressing = false
    var isJumping = false
    var multiTouchList: [UITouch: String?] = [:]
    
    override func didMove(to view: SKView) {
        //let xSize = self.frame.size.width
        //let ySize = self.frame.size.height
        
        // --- Add physics to scene, no friction, no out of frame ---
        let sceneBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = sceneBody
        sceneBody.friction = 0
        physicsWorld.contactDelegate = self
        self.view?.isMultipleTouchEnabled = true
        
        // --- Hero Texture Initialization ---
        let textureIdleAtlas = SKTextureAtlas(named: "IdleRight")
        var textureIdleArray: [SKTexture] = []
        for i in  1...textureIdleAtlas.textureNames.count {
            let name = "\(i).png"
            textureIdleArray.append(SKTexture(imageNamed: name))
        }
        
        // --- Hero Initialization
        character = SKSpriteNode(imageNamed: textureIdleAtlas.textureNames[0])
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
        addAnimation(sprite: character, animationArray: textureIdleArray)
        self.addChild(character)
        
        // --- Background initialization ---
        background = childNode(withName: "background") as! SKSpriteNode
        
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
        
        // --- Buttons initialization ---
        leftSide = childNode(withName: "leftSide") as! SKSpriteNode
        rightSide = childNode(withName: "rightSide") as! SKSpriteNode
        jumpSide = childNode(withName: "jumpSide") as! SKSpriteNode
        
        leftSide.color = .clear
        rightSide.color = .clear
        jumpSide.color = .clear
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isTouchPressing {
            for (_, activity) in multiTouchList {
                switch activity {
                    case "left":
                        character.physicsBody?.applyForce(CGVector(dx: -100, dy: 0))
                    case "right":
                        character.physicsBody?.applyForce(CGVector(dx: 100, dy: 0))
                    case "jump":
                        if !isJumping{
                            character.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
                            isJumping = true
                        }
                    default:
                        continue
                }
            }
        } else {
            character.physicsBody?.applyForce(CGVector(dx: 0, dy: 0))
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // If Hero (category 1) touches
        if contact.bodyA.categoryBitMask == 1 || contact.bodyB.categoryBitMask == 1 {
            // Platform (category 2)
            if contact.bodyA.categoryBitMask == 2 || contact.bodyB.categoryBitMask == 2 {
                isJumping = false
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchPressing = true
        for touch in touches {
            multiTouchList[touch] = findButtonPressed(from: touch)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchPressing = false
        for touch in touches {
            guard let _ = multiTouchList[touch] else { fatalError("Touch just ended but not found into multiTouchList") }
            multiTouchList.removeValue(forKey: touch)
            //multiTouchList[touch] = nil
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchPressing = false
        for touch in touches {
            guard let _ = multiTouchList[touch] else { fatalError("Touch just ended but not found into multiTouchList") }
            //multiTouchList[touch] = nil
        }
    }
    
    /// Return a string indicating what to do if touching on a specific frame
    /// - Parameter touch: UITouch element taken from touchesBegan or touchesEnded
    /// - Returns: An optional string value that can be "left", "right", "jump" or nil
    func findButtonPressed(from touch: UITouch) -> String? {
        let location = touch.location(in: self)
        if leftSide.frame.contains(location) {
            return "left"
        }
        else if rightSide.frame.contains(location) {
            return "right"
        }
        else if jumpSide.frame.contains(location) {
            return "jump"
        }
        return nil
    }
    
    func initSpriteNode(sprite: SKSpriteNode, name: String, position: CGPoint = CGPoint(x: 0, y: 0), anchorPoint: CGPoint = CGPoint(x: 0.5, y: 0.5), scale: CGFloat = 1.0, physicsBody: SKPhysicsBody? = nil, isDynamic: Bool = true, allowsRotation: Bool = false, mass: CGFloat = 0.1, affectedByGravity: Bool = false, categoryBitMask: UInt32 = 0b0, collisionsBitMask: UInt32 = 0b0, contactTestBitMask: UInt32 = 0b0)  {
        sprite.name = name
        sprite.position = position
        sprite.anchorPoint = anchorPoint
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
    
    /// Add repetitive animation to sprite
    /// - Parameters:
    ///   - sprite: Sprite that will play this animation
    ///   - animationArray: Array of textures that will animate the sprite
    func addAnimation(sprite: SKSpriteNode, animationArray: [SKTexture]) {
        sprite.run(SKAction.repeatForever(SKAction.animate(with: animationArray, timePerFrame: 0.1)))
    }
}
