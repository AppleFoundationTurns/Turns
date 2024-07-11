//
//  PlatformScene.swift
//  Turns-v1
//
//  Created by Federico Agnello on 02/07/24.
//

import SpriteKit

class PlatformScene: SKScene, SKPhysicsContactDelegate {
    
    var blueFruitListCollected:[Bool] = []
    var orangeFruitListCollected:[Bool] = []
    var blueFruitList:[SKSpriteNode] = []
    var orangeFruitList:[SKSpriteNode] = []
    
    var blueFruitLabel: SKLabelNode = SKLabelNode()
    var orangeFruitLabel: SKLabelNode = SKLabelNode()
    
    var host:Bool = true
    var hero = HeroNode()
    var flame = SKSpriteNode()
    
    var leftButton = SKSpriteNode()
    var rightButton = SKSpriteNode()
    var jumpButton = SKSpriteNode()
    var switchButton = SKSpriteNode()
    
    var isTouchPressing = false
    var isJumping = false
    var multiTouchList: [UITouch: (Direction?, Action?)] = [:]
    
    var viewModel: ViewModel = ViewModel(mpcInterface: MPCInterface())
    
    override func didMove(to view: SKView) {
        // --- ViewModel Initialization ---
        viewModel = ViewModelInjected.viewModel as! ViewModel
        
        host = !viewModel.appState.isGuest
        viewModel.currentState.username = host ? "Host" : "Guest"
        viewModel.appState.isPlaying = host
        viewModel.appState.isTutorialShown = true
        let blueFruit = Collectable.init(label: "Blue", collectables: [])
        let orangeFruit = Collectable.init(label: "Orange", collectables: [])
        viewModel.currentState.collectables.append(blueFruit)
        viewModel.currentState.collectables.append(orangeFruit)
        
        
        // --- Add physics to scene, no friction, no out of frame ---
        let sceneBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = sceneBody
        sceneBody.friction = 0
        physicsWorld.contactDelegate = self
        self.view?.isMultipleTouchEnabled = true
        
        // --- Hero Initialization ---
        hero = HeroNode(atlasName: host ? "blueIdle" : "orangeIdle", scale: 2.0, host: host)
        hero.animations.jump = hero.addAtlas(atlasName: host ? "blueJump" : "orangeJump")
        hero.animations.run = hero.addAtlas(atlasName: host ? "blueRunFix" : "orangeRun")
        self.addChild(hero)
        
        // --- Flame Initialization ---
        let oldFlame = childNode(withName: "flame") as! SKSpriteNode
        flame = FlameNode(position: oldFlame.position, atlasName: "Flame", scale: 0.5)
        oldFlame.removeFromParent()
        PhysicsCategory.flame = PhysicsCategory.flameBackup
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
            } else if node.name == "blueFruit" {
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode {
                    giveCollectablesPhysicsBody(tileMap: someTileMap, fruitList: &blueFruitList, fruitCollectedList: &blueFruitListCollected,categoryBitMask: PhysicsCategory.blueFruit)
                    someTileMap.removeFromParent()
                }
            } else if node.name == "orangeFruit" {
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode {
                    giveCollectablesPhysicsBody(tileMap: someTileMap, fruitList: &orangeFruitList, fruitCollectedList: &orangeFruitListCollected,categoryBitMask: PhysicsCategory.orangeFruit)
                    someTileMap.removeFromParent()
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
        
        
        // --- Fruit Counter initialization ---
        let blueFruitIcon = self.childNode(withName: "blueFruitIcon") as! SKSpriteNode
        let orangeFruitIcon = self.childNode(withName: "orangeFruitIcon") as! SKSpriteNode
        blueFruitIcon.texture!.filteringMode = .nearest
        orangeFruitIcon.texture!.filteringMode = .nearest
        
        blueFruitLabel = blueFruitIcon.childNode(withName: "blueFruitLabel") as! SKLabelNode
        orangeFruitLabel = orangeFruitIcon.childNode(withName: "orangeFruitLabel") as! SKLabelNode
        
        blueFruitLabel.fontName = "ArcadeClassic"
        orangeFruitLabel.fontName = "ArcadeClassic"
        blueFruitLabel.fontColor = .blue
        orangeFruitLabel.fontColor = .orange
        blueFruitLabel.fontSize = 50
        orangeFruitLabel.fontSize = 50
        
        updateFruitCounter()
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isTouchPressing {
            for (_, activity) in multiTouchList {
                switch activity {
                case (.left, .move):
                    hero.action = .move
                    hero.physicsBody?.applyForce(CGVector(dx: -80, dy: 0))
                    if hero.actualAnimation != hero.animations.run || hero.direction != .left {
                        hero.direction = .left
                        hero.animate(animation: hero.animations.run, speed: 0.08)
                    }
                case (.right, .move):
                    hero.action = .move
                    hero.physicsBody?.applyForce(CGVector(dx: 80, dy: 0))
                    if hero.actualAnimation != hero.animations.run || hero.direction != .right {
                        hero.direction = .right
                        hero.animate(animation: hero.animations.run, speed: 0.08)
                    }
                case (_, .jump):
                    hero.action = .jump
                    if !isJumping{
                        hero.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                        hero.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
                        isJumping = true
                    }
                    if hero.actualAnimation != hero.animations.jump {
                        hero.animate(animation: hero.animations.jump, speed: 0.1)
                    }
                default:
                    continue
                }
            }
        } else {
            hero.action = .idle
            hero.physicsBody?.applyForce(CGVector(dx: 0, dy: 0))
            if hero.actualAnimation != hero.animations.idle && !isJumping {
                hero.animate(animation: hero.animations.idle)
            }
        }
        
        if let body = hero.physicsBody {
            let dy = body.velocity.dy
            if dy > 0 { body.collisionBitMask &= host ? ~PhysicsCategory.bluePlatform : ~PhysicsCategory.orangePlatform}
            else {
                body.collisionBitMask |= host ? PhysicsCategory.bluePlatform : PhysicsCategory.orangePlatform
            }
        }
            
        if(viewModel.currentState.newInfo){ // Se ho ricevuto un nuovo pacchetto
            viewModel.currentState.newInfo = false
            viewModel.appState.isPlaying = true
            
            hero.position.x = CGFloat(viewModel.currentState.positionX)
            hero.position.y = CGFloat(viewModel.currentState.positionY)
            hero.physicsBody!.velocity.dx = CGFloat(viewModel.currentState.velocityX)
            hero.physicsBody!.velocity.dy = CGFloat(viewModel.currentState.velocityY)
            
            updateCollectables(blueFruitListCollected: viewModel.currentState.collectables[0].collectables, orangeFruitListCollected: viewModel.currentState.collectables[1].collectables)
            updateFruitCounter()
            
        }
        
        
        viewModel.currentState.positionX = Float(hero.position.x)
        viewModel.currentState.positionY = Float(hero.position.y)
        viewModel.currentState.velocityX = Float(hero.physicsBody!.velocity.dx)
        viewModel.currentState.velocityY = Float(hero.physicsBody!.velocity.dy)
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
            if (bodyB == PhysicsCategory.blueFruit) {
                handleContactBetweenPlayerAndFruit(playerBody: contact.bodyA, fruitBody: contact.bodyB)
            }
            if (bodyB == PhysicsCategory.flame){
                // End Game
                viewModel.currentState.newInfo = true
                viewModel.mpcInterface.sendState()
                viewModel.currentState.newInfo = false
                PhysicsCategory.flame = PhysicsCategory.none
                viewModel.appState.isCompletedLevel = true
            }
        } else if bodyA == PhysicsCategory.orangeHero {
            if (bodyB == PhysicsCategory.orangePlatform) || (bodyB == PhysicsCategory.ground && (-1.1)...(-0.9) ~= contact.contactNormal.dy) {
                isJumping = false
                
            }
            if (bodyB == PhysicsCategory.orangeFruit) {
                handleContactBetweenPlayerAndFruit(playerBody: contact.bodyA, fruitBody: contact.bodyB)
            }
            if (bodyB == PhysicsCategory.flame){
                // End Game
                viewModel.currentState.newInfo = true
                viewModel.mpcInterface.sendState()
                viewModel.currentState.newInfo = false
                PhysicsCategory.flame = PhysicsCategory.none
                viewModel.appState.isCompletedLevel = true
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchPressing = true
        for touch in touches {
            multiTouchList[touch] = findButtonPressed(from: touch)
            let loc = touch.location(in: self)
            if switchButton.frame.contains(loc) {
                switchButton.color = .black
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch in touches {
            guard let _ = multiTouchList[touch] else { fatalError("Touch just ended but not found into multiTouchList") }
            multiTouchList.removeValue(forKey: touch)
            let loc = touch.location(in: self)
            if switchButton.frame.contains(loc) {
                viewModel.currentState.newInfo = true
                viewModel.mpcInterface.sendState()
                viewModel.currentState.newInfo = false
                viewModel.appState.isPlaying = false
            }
        }
        if multiTouchList.isEmpty { isTouchPressing = false }
        leftButton.color = .clear
        rightButton.color = .clear
        jumpButton.color = .clear
        switchButton.color = .clear
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
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
    func giveTileMapPhysicsBody(tileMap: SKTileMapNode, categoryBitMask: UInt32, collisionBitMask: UInt32 = 0b0, contactTestBitMask: UInt32 = 0b0){
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
            loadnode.physicsBody?.collisionBitMask = collisionBitMask
            loadnode.physicsBody?.contactTestBitMask = contactTestBitMask
            loadnode.physicsBody?.restitution = 0
            
            loadnode.position.x = t.x + size.width / 2
            loadnode.position.y = t.y + size.height / 2
            
            scene?.addChild(loadnode)
            
            // Increase index for right edges
            ti2 += 1
        }
    }
    
    func giveCollectablesPhysicsBody(tileMap: SKTileMapNode, fruitList: inout [SKSpriteNode], fruitCollectedList: inout [Bool], categoryBitMask: UInt32, collisionBitMask: UInt32 = 0b0, contactTestBitMask: UInt32 = 0b0) {

        let startingLocation: CGPoint = tileMap.position
        let tileSize = tileMap.tileSize
        let scaleFactor: CGFloat = 3.0 // Fattore di scala

        let halfWidth = CGFloat(tileMap.numberOfColumns) / 2.0 * tileSize.width * scaleFactor
        let halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height * scaleFactor

        for col in 0 ..< tileMap.numberOfColumns {
            for row in 0 ..< tileMap.numberOfRows {

                if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row) {

                    let tileArray = tileDefinition.textures
                    let tileTexture = tileArray[0]
                    tileTexture.filteringMode = .nearest
                    let x = CGFloat(col) * tileSize.width * scaleFactor - halfWidth + (tileSize.width * scaleFactor / 2)
                    let y = CGFloat(row) * tileSize.height * scaleFactor - halfHeight + (tileSize.height * scaleFactor / 2)

                    let tileNode = SKSpriteNode(texture: tileTexture)
                    tileNode.position = CGPoint(x: x, y: y)
                    tileNode.setScale(scaleFactor) // Scala il nodo

                    // Crea il physics body con le dimensioni scalate
                    tileNode.physicsBody = SKPhysicsBody(texture: tileTexture, size: CGSize(width: tileTexture.size().width * scaleFactor, height: tileTexture.size().height * scaleFactor))
                    tileNode.physicsBody?.linearDamping = 60
                    tileNode.physicsBody?.affectedByGravity = false
                    tileNode.physicsBody?.allowsRotation = false
                    tileNode.physicsBody?.isDynamic = false
                    tileNode.physicsBody?.friction = 1
                    tileNode.physicsBody?.categoryBitMask = categoryBitMask
                    tileNode.physicsBody?.collisionBitMask = collisionBitMask
                    tileNode.physicsBody?.contactTestBitMask = contactTestBitMask
                    
                    
                    fruitList.append(tileNode)
                    fruitCollectedList.append(false)
                    self.addChild(tileNode)

                    tileNode.position = CGPoint(x: tileNode.position.x + startingLocation.x, y: tileNode.position.y + startingLocation.y)
                }

            }
        }
    }
    
    func updateCollectables(blueFruitListCollected: [Bool], orangeFruitListCollected: [Bool]) {
        // Mi assicuro che gli array abbiano la stessa lunghezza
        guard blueFruitListCollected.count == blueFruitList.count,
              orangeFruitListCollected.count == orangeFruitList.count else {
            print("Array lengths do not match")
            return
        }
        
        // Rimuovo i nodi dai blueFruitList se il corrispondente booleano è true
        for (index, collected) in blueFruitListCollected.enumerated().reversed() {
            if collected {
                let node = blueFruitList[index]
                node.removeFromParent()
                //blueFruitList.remove(at: index)
            }
        }

        for (index, collected) in orangeFruitListCollected.enumerated().reversed() {
            if collected {
                let node = orangeFruitList[index]
                node.removeFromParent()
                //orangeFruitList.remove(at: index)
            }
        }
        self.blueFruitListCollected = blueFruitListCollected
        self.orangeFruitListCollected = orangeFruitListCollected
    }
    
    func handleContactBetweenPlayerAndFruit(playerBody: SKPhysicsBody, fruitBody: SKPhysicsBody) {
        if let node = fruitBody.node {
            // Verifica se il nodo è in blueFruitList
            if let index = blueFruitList.firstIndex(of: node as! SKSpriteNode) {
                //blueFruitList.remove(at: index)
                blueFruitListCollected[index] = true
                node.removeFromParent()
                print("Blue fruit at index \(index) collected.\nNew Blue Fruit Array: \(blueFruitListCollected)")
            }
            // Verifica se il nodo è in orangeFruitList
            else if let index = orangeFruitList.firstIndex(of: node as! SKSpriteNode) {
                //orangeFruitList.remove(at: index)
                orangeFruitListCollected[index] = true
                node.removeFromParent()
                print("Orange fruit at index \(index) collected.\nNew Orange Fruit Array: \(orangeFruitListCollected)")
            }
            
            updateFruitCounter()
        }
    }
    
    func updateFruitCounter() {
        let totalBlueFruits = blueFruitListCollected.count
        let totalOrangeFruits = orangeFruitListCollected.count
        let collectedBlueFruits = blueFruitListCollected.filter { $0 }.count
        let collectedOrangeFruits = orangeFruitListCollected.filter { $0 }.count
        
        blueFruitLabel.text = "\(collectedBlueFruits) / \(totalBlueFruits)"
        orangeFruitLabel.text = "\(collectedOrangeFruits) / \(totalOrangeFruits)"

        /*
        let counterText = "Blue: \(collectedBlueFruits) / \(totalBlueFruits)   Orange: \(collectedOrangeFruits) / \(totalOrangeFruits)"
        
        let attributedString = NSMutableAttributedString(string: counterText)
        
        let font = UIFont(name: "ArcadeClassic", size: 50)
        
        let blueRange = (counterText as NSString).range(of: "Blue: \(collectedBlueFruits) / \(totalBlueFruits)")
        let orangeRange = (counterText as NSString).range(of: "Orange: \(collectedOrangeFruits) / \(totalOrangeFruits)")
        
        attributedString.addAttribute(.font, value: font!, range: NSRange(location: 0, length: counterText.count))
        attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: blueRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.orange, range: orangeRange)
        
        fruitCounterLabel.attributedText = attributedString*/
        
        viewModel.currentState.collectables[0].collectables = blueFruitListCollected
        viewModel.currentState.collectables[1].collectables = orangeFruitListCollected
    }

}
