//
//  HeroNode.swift
//  Turns-v1
//
//  Created by Giuseppe Damiata on 03/07/24.
//

import SpriteKit

class HeroNode: SKSpriteNode {
    var allAnimations: [String: [SKTexture]] = [:]
    
    // init Hero with the atlas [reccommended: Idle] and animate it. Set scale and default physics.
    init(atlasName: String, scale: CGFloat = 1.0) {
        let atlas = SKTextureAtlas(named: atlasName)
        var textures: [SKTexture] = []
        for i in  1...atlas.textureNames.count {
            let name = "\(i).png"
            textures.append({
                let texture = SKTexture(imageNamed: name)
                texture.filteringMode = .nearest // For upscaling with better results
                return texture
            }())
        }
        allAnimations[atlasName] = textures
        let firstTexture = allAnimations[atlasName]!.first
        
        super.init(texture: firstTexture, color: .clear, size: firstTexture!.size() )
        self.name = "Hero"
        self.position = CGPoint(x: -450, y: -150)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsBody = SKPhysicsBody(texture: firstTexture!, size: firstTexture!.size() )
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.mass = 0.1
        self.physicsBody?.categoryBitMask = 0b01
        self.physicsBody?.collisionBitMask = 0b10
        self.physicsBody?.contactTestBitMask = 0b10
        self.setScale(scale)
        self.animate(animation: allAnimations[atlasName]!)
    }
    
    required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
    
    func addAtlas(atlasName: String) {
        let atlas = SKTextureAtlas(named: atlasName)
        var textures: [SKTexture] = []
        for i in  1...atlas.textureNames.count {
            let name = "\(i).png"
            textures.append({
                let texture = SKTexture(imageNamed: name)
                texture.filteringMode = .nearest // For upscaling with better results
                return texture
            }())
        }
        allAnimations[atlasName] = textures
    }
    
    func animate(animation: [SKTexture]) {
        self.removeAllActions()
        self.run(.repeatForever(.animate(with: animation, timePerFrame: 0.1)))
    }
}
