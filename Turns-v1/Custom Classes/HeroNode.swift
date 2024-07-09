//
//  HeroNode.swift
//  Turns-v1
//
//  Created by Giuseppe Damiata on 03/07/24.
//

import SpriteKit

class HeroNode: SKSpriteNode {
    var allAnimations: [String: [SKTexture]] = [:]
    var actualAnimation: [SKTexture]
    var action: Action = .idle
    var direction: Direction = .right
    private var actualScale = 1.0
    
    override func setScale(_ scale: CGFloat) {
        if actualScale != scale {actualScale = scale}
        super.setScale(scale)
    }
    
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
        self.actualAnimation = allAnimations[atlasName]!
        super.init(texture: firstTexture, color: .clear, size: firstTexture!.size() )
        self.name = "Hero"
        self.position = CGPoint(x: -450, y: -50)
        self.anchorPoint = CGPoint(x: 0.5, y: 0)
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width * 0.7, height: self.size.height * 0.7), center: CGPoint(x: 0, y: self.size.height * 0.7 / 2))
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.mass = 0.1
        self.physicsBody?.restitution = 0
        self.physicsBody?.categoryBitMask = PhysicsCategory.blueHero
        self.physicsBody?.collisionBitMask = PhysicsCategory.ground
        self.physicsBody?.contactTestBitMask = PhysicsCategory.all
        self.physicsBody?.usesPreciseCollisionDetection = false
        self.setScale(scale)
        actualScale = scale
        self.animate(animation: allAnimations[atlasName]!)
        
    }
    
    convenience init() {
        self.init(atlasName: "blueIdle", scale:1.0)
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
    
    func animate(animation: [SKTexture], speed: CGFloat = 0.2) {
        self.removeAllActions()
        if self.direction == .left {self.run(.scaleX(to: -actualScale, duration: 0.05))}
        else {self.run(.scaleX(to: actualScale, duration: 0.05))}
        self.run(.repeatForever(.animate(with: animation, timePerFrame: speed)))
        self.actualAnimation = animation
    }
}
