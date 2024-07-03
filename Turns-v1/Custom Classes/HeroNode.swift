//
//  HeroNode.swift
//  Turns-v1
//
//  Created by Giuseppe Damiata on 03/07/24.
//

import SpriteKit

class HeroNode: SKSpriteNode {
    var allAnimations: [String: [SKTexture]] = [:]
    
    init(atlasName: String) {
        let atlas = SKTextureAtlas(named: atlasName)
        var textures: [SKTexture] = []
        for i in  1...atlas.textureNames.count {
            let name = "\(i).png"
            
            textures.append(SKTexture(imageNamed: name))
        }
        allAnimations[atlasName] = textures
        let firstTexture = allAnimations[atlasName]!.first
        
        super.init(texture: firstTexture, color: .clear, size: firstTexture!.size())
        self.position = CGPoint(x: 0, y: 0)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
}
