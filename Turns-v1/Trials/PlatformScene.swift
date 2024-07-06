//
//  PlatformScene.swift
//  Turns-v1
//
//  Created by Federico Agnello on 02/07/24.
//

import SpriteKit

class PlatformScene: SKScene, SKPhysicsContactDelegate {
    
    var hero = HeroNode()
    var flame = SKSpriteNode()
    
    var leftButton = SKSpriteNode()
    var rightButton = SKSpriteNode()
    var jumpButton = SKSpriteNode()
    
    var isTouchPressing = false
    var isJumping = false
    var multiTouchList: [UITouch: (Direction?, Action?)] = [:]
    
    override func didMove(to view: SKView) {
        
        // --- Add physics to scene, no friction, no out of frame ---
        let sceneBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = sceneBody
        sceneBody.friction = 0
        physicsWorld.contactDelegate = self
        self.view?.isMultipleTouchEnabled = true
        
        // --- Hero Initialization ---
        hero = HeroNode(atlasName: "Idle", scale: 2.0)
        hero.addAtlas(atlasName: "Jump")
        hero.addAtlas(atlasName: "Run")
        self.addChild(hero)
        
        // --- Flame Initialization ---
        let oldFlame = childNode(withName: "flame") as! SKSpriteNode
        flame = FlameNode(position: oldFlame.position, atlasName: "Flame", scale: 0.5)
        oldFlame.removeFromParent()
        self.addChild(flame)
        
        // --- Platform initialization ---
        for node in self.children {
            if node.name == "deco" {
                if let node: SKSpriteNode = node as? SKSpriteNode {
                    node.texture?.filteringMode = .nearest
                    node.physicsBody = nil
                }
            }
            
            if (node.name == "Platforms") {
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode {
                    giveTileMapPhysicsBody(tileMap: someTileMap)
                }
            }
        }
        
        // --- Buttons initialization ---
        leftButton = childNode(withName: "Directions//leftButton") as! SKSpriteNode
        rightButton = childNode(withName: "Directions//rightButton") as! SKSpriteNode
        jumpButton = childNode(withName: "jumpButton") as! SKSpriteNode
        
        leftButton.texture?.filteringMode = .nearest
        rightButton.texture?.filteringMode = .nearest
        jumpButton.texture?.filteringMode = .nearest
        
        leftButton.colorBlendFactor = 0.5
        rightButton.colorBlendFactor = 0.5
        jumpButton.colorBlendFactor = 0.5
        
        leftButton.color = .clear
        rightButton.color = .clear
        jumpButton.color = .clear
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isTouchPressing {
            for (_, activity) in multiTouchList {
                switch activity {
                case (.left, .move):
                        hero.direction = .left
                        hero.action = .move
                        hero.physicsBody?.applyForce(CGVector(dx: -100, dy: 0))
                        if hero.actualAnimation != hero.allAnimations["Run"]! {
                            hero.animate(animation: hero.allAnimations["Run"]!, speed: 0.08)
                        }
                case (.right, .move):
                        hero.direction = .right
                        hero.action = .move
                        hero.physicsBody?.applyForce(CGVector(dx: 100, dy: 0))
                        if hero.actualAnimation != hero.allAnimations["Run"]! {
                            hero.animate(animation: hero.allAnimations["Run"]!, speed: 0.08)
                        }
                case (_, .jump):
                        hero.action = .jump
                        if !isJumping{
                            hero.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 80))
                            isJumping = true
                        }
                        if hero.actualAnimation != hero.allAnimations["Jump"]! {
                            hero.animate(animation: hero.allAnimations["Jump"]!, speed: 0.1)
                        }
                    default:
                        continue
                }
            }
        } else {
            hero.action = .idle
            hero.physicsBody?.applyForce(CGVector(dx: 0, dy: 0))
            if hero.actualAnimation != hero.allAnimations["Idle"]! && !isJumping {
                hero.animate(animation: hero.allAnimations["Idle"]!)
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("\(contact.bodyA.categoryBitMask) is colliding with \(contact.bodyB.categoryBitMask ) in direction \(contact.contactNormal)")
        // If Hero (category 1) touches
        if contact.bodyA.categoryBitMask == 1 || contact.bodyB.categoryBitMask == 1 {
            // Platform (category 2)
            if contact.bodyA.categoryBitMask == 2 || contact.bodyB.categoryBitMask == 2 {
                // If the contact is only from upside
                if contact.contactNormal.dy <= -0.9 && contact.contactNormal.dy >= -1.1 {
                    isJumping = false
                }
                
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
        leftButton.color = .clear
        rightButton.color = .clear
        jumpButton.color = .clear
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
    func findButtonPressed(from touch: UITouch) -> (Direction?, Action?) {
        let location = touch.location(in: self)
        if leftButton.frame.contains(location) {
            leftButton.color = .black
            return (.left, .move)
        }
        else if rightButton.frame.contains(location) {
            rightButton.color = .black
            return (.right, .move)
        }
        else if jumpButton.frame.contains(location) {
            jumpButton.color = .black
            return (hero.direction, .jump)
        }
        return (nil, nil)
    }

    /// Function to create and assign physics bodies to the tiles in a given tile map.
    /// - Parameter tileMap: The `SKTileMapNode` representing the tile map to which physics bodies will be assigned.
    /// This function iterates through all the tiles in the provided tile map. For each tile that is not null, it creates an `SKSpriteNode`, calculates its position, and adds it to arrays tracking the tiles and their positions. It then groups adjacent tiles together to form larger physics bodies, which are added to the scene with specified physics properties.
    func giveTileMapPhysicsBody(tileMap: SKTileMapNode){
        var tileArray:[SKSpriteNode] = []
        var tilePositionArray:[CGPoint] = []
        
        let tilesize = tileMap.tileSize
        
        let halfwidth = CGFloat(tileMap.numberOfColumns) / 2.0 * tilesize.width
        let halfheight =  CGFloat(tileMap.numberOfRows) / 2.0 * tilesize.height

        for col in 0 ..< tileMap.numberOfColumns {
            for row in 0 ..< tileMap.numberOfRows {
                // Check if the node of the timeMap is not null
                // TODO: check the specific tile, to have different platforms collisions
                if (tileMap.tileDefinition(atColumn: col, row: row) != nil) {
                    
                    let tileDef = tileMap.tileDefinition(atColumn: col, row: row)!
                    
                    // Creates a new sprite node for the tile
                    let tile = SKSpriteNode()
                    let x = round(CGFloat(col) * tilesize.width - halfwidth + (tilesize.width / 2))
                    let y = round(CGFloat(row) * tilesize.height - halfheight + (tilesize.height / 2))
                    tile.position = CGPoint(x: x, y: y)
                    tile.size = CGSize(width: tileDef.size.width, height: tileDef.size.height)
                    
                    // Adds the tile and its location to the corresponding arrays
                    tileArray.append(tile)
                    tilePositionArray.append(tile.position)
                }
            }
        }
        
        // Algorithm for tile grouping
        
        let width = tilesize.width
        let height = tilesize.height
        let rWidth = 0.5 * width
        let rHeight = 0.5 * height

        var ti:Int = 0
        var ti2:Int = 0
        var id:Int = 0
        var dl:CGPoint = CGPoint(x: 0, y: 0)

        // Arrays for the coordinates of the left and right edges of the tiles
        var tLE = [CGPoint]()
        var tRE = [CGPoint]()

        for t in tilePositionArray {
            // Checks whether the previous tile is not vertically adjacent
            if (ti-1 < 0) || (tilePositionArray[ti-1].y != tilePositionArray[ti].y - height) {
                dl = CGPoint(x: t.x - rWidth, y: t.y - rHeight)
            }

            // Checks whether the next tile is not vertically adjacent
            if (ti+1 > tilePositionArray.count-1) {
                tLE.append(dl)
                tRE.append(CGPoint(x: t.x + rWidth, y: t.y + rHeight))
            } else if (tilePositionArray[ti+1].y != tilePositionArray[ti].y + height) {
                if let _ = tRE.first(where: {
                    // Check if there is an adjacent tile in the right edge
                    if $0 == CGPoint(x: t.x + rWidth - width, y: t.y + rHeight) {id = tRE.firstIndex(of: $0)!}
                    return $0 == CGPoint(x: t.x + rWidth - width, y: t.y + rHeight)}) {
                    
                    // If the adjacent tile has the same height as the left edge, update the right edge
                    if tLE[id].y == dl.y {
                        tRE[id] = CGPoint(x: t.x + rWidth, y: t.y + rHeight)
                    } else {
                        // Otherwise, it adds new left and right edges
                        tLE.append(dl)
                        tRE.append(CGPoint(x: t.x + rWidth, y: t.y + rHeight))
                    }
                } else {
                    // If no adjacent tile exists, adds new left and right edges
                    tLE.append(dl)
                    tRE.append(CGPoint(x: t.x + rWidth, y: t.y + rHeight))
                }
            }
            // Increases the index of the tile
            ti+=1
        }

        // Iterate on all tiles to create physics nodes
        for t in tLE {
            // Calculate the rectangle size
            let size = CGSize(width: abs(t.x - tRE[ti2].x), height: abs(t.y - tRE[ti2].y))
            let loadnode = SKNode()
            
            // Creates the physicBody for the node
            loadnode.physicsBody = SKPhysicsBody(rectangleOf: size)
            loadnode.physicsBody?.linearDamping = 60
            loadnode.physicsBody?.affectedByGravity = false
            loadnode.physicsBody?.allowsRotation = false
            loadnode.physicsBody?.isDynamic = false
            loadnode.physicsBody?.friction = 1
            loadnode.physicsBody?.categoryBitMask = 0b10
            loadnode.physicsBody?.collisionBitMask = 0b0
            loadnode.physicsBody?.contactTestBitMask = 0b0
            loadnode.physicsBody?.restitution = 0
            
            loadnode.position.x = t.x + size.width / 2
            loadnode.position.y = t.y + size.height / 2
            
            scene?.addChild(loadnode)
            
            // Increase index for right edges
            ti2 += 1
        }
    }
}
