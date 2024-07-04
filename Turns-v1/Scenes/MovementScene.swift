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
        
        // --- Hero Initialization ---
        character = HeroNode(atlasName: "Idle", scale: 2.0)
        self.addChild(character)
        
        // --- Background initialization ---
        background = childNode(withName: "background") as! SKSpriteNode
        
        // --- Platform initialization ---
        for node in self.children {
            if (node.name == "platforms") {
                if let someTileMap: SKTileMapNode = node as? SKTileMapNode {
                    giveTileMapPhysicsBody(tileMap: someTileMap)
                    someTileMap.removeFromParent()
                }
            }
        }
        
        // --- Buttons initialization ---
        leftSide = childNode(withName: "leftSide") as! SKSpriteNode
        rightSide = childNode(withName: "rightSide") as! SKSpriteNode
        jumpSide = childNode(withName: "jumpSide") as! SKSpriteNode
        
        leftSide.color = .clear
        rightSide.color = .clear
        jumpSide.color = .clear
        
        
    }
    var i = 0;
    
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
        print("\(contact.bodyA.categoryBitMask) is colliding with \(contact.bodyB.categoryBitMask )")
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
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchPressing = false
        for touch in touches {
            guard let _ = multiTouchList[touch] else { fatalError("Touch just ended but not found into multiTouchList") }
            multiTouchList.removeValue(forKey: touch)
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
    
    /// Add repetitive animation to sprite
    /// - Parameters:
    ///   - sprite: Sprite that will play this animation
    ///   - animationArray: Array of textures that will animate the sprite
    func addAnimation(sprite: SKSpriteNode, animationArray: [SKTexture]) {
        sprite.run(SKAction.repeatForever(SKAction.animate(with: animationArray, timePerFrame: 0.1)))
    }
    
    func giveTileMapPhysicsBody(tileMap: SKTileMapNode) {
        
        let startingLocation :CGPoint = tileMap.position
        
        let tileSize = tileMap.tileSize
        
        let halfWidth = CGFloat(tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height
        
        for col in 0 ..< tileMap.numberOfColumns {
            for row in 0 ..< tileMap.numberOfRows {
                
                if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row) {
                    
                    let tileArray = tileDefinition.textures
                    let tileTexture = tileArray[0]
                    let x = CGFloat(col) * tileSize.width - halfWidth + (tileSize.width / 2)
                    let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height / 2)
                    
                    let tileNode = SKSpriteNode(texture: tileTexture)
                    tileNode.position = CGPoint(x: x, y: y)
                    tileNode.physicsBody = SKPhysicsBody(texture: tileTexture, size: CGSize(width: tileTexture.size().width, height: tileTexture.size().height))
                    tileNode.physicsBody?.linearDamping = 60
                    tileNode.physicsBody?.affectedByGravity = false
                    tileNode.physicsBody?.allowsRotation = false
                    tileNode.physicsBody?.isDynamic = false
                    tileNode.physicsBody?.friction = 1
                    tileNode.physicsBody?.categoryBitMask = 0b10
                    tileNode.physicsBody?.collisionBitMask = 0b0
                    tileNode.physicsBody?.contactTestBitMask = 0b0
                    self.addChild(tileNode)
                    
                    tileNode.position = CGPoint(x: tileNode.position.x + startingLocation.x, y: tileNode.position.y + startingLocation.y)
                }
                
            }
        }
    }
}
