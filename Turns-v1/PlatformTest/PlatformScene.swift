//
//  PlatformScene.swift
//  Turns-v1
//
//  Created by Federico Agnello on 02/07/24.
//

import SpriteKit

class PlatformScene: SKScene {
    
    override func didMove(to view: SKView) {
        for node in self.children {
            if (node.name == "Platforms") {
                if let someTileMap:SKTileMapNode = node as? SKTileMapNode {
                    giveTileMapPhysicsBody(tileMap: someTileMap)
                    someTileMap.removeFromParent()
                }
            }
        }
        /*
        print(platformTileMap)
        print(platformTileMap.numberOfRows)
        print(platformTileMap.numberOfColumns)
        print(platformTileMap.tileDefinition(atColumn: 1, row: 1))
        
        let someTile = platformTileMap.tileDefinition(atColumn: 1, row: 1)
        print(someTile?.textures)
         */
        
        
    }
    
    func giveTileMapPhysicsBody(tileMap: SKTileMapNode) {
        
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
