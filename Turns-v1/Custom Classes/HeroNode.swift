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
        self.position = CGPoint(x: -450, y: -50)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.7, height: self.size.height))
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.mass = 0.1
        self.physicsBody?.categoryBitMask = 0b01
        self.physicsBody?.collisionBitMask = 0b10
        self.physicsBody?.contactTestBitMask = 0b10
        self.physicsBody?.usesPreciseCollisionDetection = false
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
        self.run(.repeatForever(.animate(with: animation, timePerFrame: 0.2)))
    }
}

class FlameNode: HeroNode {
    init(position: CGPoint, atlasName: String, scale: CGFloat = 1.0) {
        super.init(atlasName: atlasName, scale: scale)
        self.name = "Flame"
        self.position = position
        self.physicsBody?.categoryBitMask = 0b100
        self.physicsBody?.isDynamic = false
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = 0
    }
    
    required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
}
