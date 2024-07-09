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
    var switchButton = SKSpriteNode()
    
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
        hero = HeroNode(atlasName: "blueIdle", scale: 2.0)
        hero.addAtlas(atlasName: "blueJump")
        hero.addAtlas(atlasName: "blueRun")
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
            
            if node.name == "Grounds" {
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode {
                    giveTileMapPhysicsBody(tileMap: someTileMap, categoryBitMask: PhysicsCategory.ground)
                }
            } else if node.name == "bluePlatforms" {
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode {
                    giveTileMapPhysicsBody(tileMap: someTileMap, categoryBitMask: PhysicsCategory.bluePlatform)
                }
            } else if node.name == "orangePlatforms" {
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode {
                    giveTileMapPhysicsBody(tileMap: someTileMap, categoryBitMask: PhysicsCategory.orangePlatform)
                }
            }
        }
        
        // --- Buttons initialization ---
        leftButton = childNode(withName: "leftButton") as! SKSpriteNode
        rightButton = childNode(withName: "rightButton") as! SKSpriteNode
        jumpButton = childNode(withName: "jumpButton") as! SKSpriteNode
        switchButton = childNode(withName: "switchButton") as! SKSpriteNode
        
        leftButton.texture?.filteringMode = .nearest
        rightButton.texture?.filteringMode = .nearest
        jumpButton.texture?.filteringMode = .nearest
        switchButton.texture?.filteringMode = .nearest
        
        leftButton.colorBlendFactor = 0.5
        rightButton.colorBlendFactor = 0.5
        jumpButton.colorBlendFactor = 0.5
        switchButton.colorBlendFactor = 0.5
        
        leftButton.color = .clear
        rightButton.color = .clear
        jumpButton.color = .clear
        switchButton.color = .clear
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isTouchPressing {
            for (_, activity) in multiTouchList {
                switch activity {
                case (.left, .move):
                    hero.action = .move
                    hero.physicsBody?.applyForce(CGVector(dx: -80, dy: 0))
                    if hero.actualAnimation != hero.allAnimations["blueRun"]! || hero.direction != .left {
                        hero.direction = .left
                        hero.animate(animation: hero.allAnimations["blueRun"]!, speed: 0.08)
                    }
                case (.right, .move):
                    hero.action = .move
                    hero.physicsBody?.applyForce(CGVector(dx: 80, dy: 0))
                    if hero.actualAnimation != hero.allAnimations["blueRun"]! || hero.direction != .right {
                        hero.direction = .right
                        hero.animate(animation: hero.allAnimations["blueRun"]!, speed: 0.08)
                    }
                case (_, .jump):
                    hero.action = .jump
                    if !isJumping{
                        hero.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                        hero.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
                        isJumping = true
                    }
                    if hero.actualAnimation != hero.allAnimations["blueJump"]! {
                        hero.animate(animation: hero.allAnimations["blueJump"]!, speed: 0.1)
                    }
                default:
                    continue
                }
            }
        } else {
            hero.action = .idle
            hero.physicsBody?.applyForce(CGVector(dx: 0, dy: 0))
            if hero.actualAnimation != hero.allAnimations["blueIdle"]! && !isJumping {
                hero.animate(animation: hero.allAnimations["blueIdle"]!)
            }
        }
        
        if let body = hero.physicsBody {
            let dy = body.velocity.dy
            if dy > 0 { body.collisionBitMask &= ~PhysicsCategory.bluePlatform }
            else {
                body.collisionBitMask |= PhysicsCategory.bluePlatform
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("\(contact.bodyA.categoryBitMask) is colliding with \(contact.bodyB.categoryBitMask ) in direction \(contact.contactNormal)")
        let bodyA = min(contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask)
        let bodyB = max(contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask)
        // If Hero (category 1) touches something
        if bodyA == PhysicsCategory.blueHero {
            // Platform (category 8) or Ground but only from upside [normalY is contained between -1.1 and -0.9]
            if (bodyB == PhysicsCategory.bluePlatform) || (bodyB == PhysicsCategory.ground && (-1.1)...(-0.9) ~= contact.contactNormal.dy) {
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
        
        
        for touch in touches {
            guard let _ = multiTouchList[touch] else { fatalError("Touch just ended but not found into multiTouchList") }
            multiTouchList.removeValue(forKey: touch)
        }
        if multiTouchList.isEmpty { isTouchPressing = false }
        leftButton.color = .clear
        rightButton.color = .clear
        jumpButton.color = .clear
        switchButton.color = .clear
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
        else if switchButton.frame.contains(location) {
            switchButton.color = .black
            print("Switch button not implemented yet")
            return (nil,nil)
        }
        return (nil, nil)
    }
    
    /// Function to create and assign physics bodies to the tiles in a given tile map.
    /// - Parameter tileMap: The `SKTileMapNode` representing the tile map to which physics bodies will be assigned.
    /// This function iterates through all the tiles in the provided tile map. For each tile that is not null, it creates an `SKSpriteNode`, calculates its position, and adds it to arrays tracking the tiles and their positions. It then groups adjacent tiles together to form larger physics bodies, which are added to the scene with specified physics properties.
    func giveTileMapPhysicsBody(tileMap: SKTileMapNode, categoryBitMask: UInt32){
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
            loadnode.physicsBody?.friction = 0.8
            loadnode.physicsBody?.categoryBitMask = categoryBitMask
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
    
    func giveCollectablesPhysicsBody(tileMap: SKTileMapNode) {

            let startingLocation :CGPoint = tileMap.position

            let tileSize = tileMap.tileSize

            let halfWidth = CGFloat(tileMap.numberOfColumns) / 2.0 * tileSize.width
            let halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height

            for col in 0 ..< tileMap.numberOfRows {
                for row in 0 ..< tileMap.numberOfColumns {

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
                        self.addChild(tileNode)

                        tileNode.position = CGPoint(x: tileNode.position.x + startingLocation.x, y: tileNode.position.y + startingLocation.y)
                    }

                }
            }
        }
}
