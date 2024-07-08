//
//  FlameNode.swift
//  Turns-v1
//
//  Created by Giuseppe Damiata on 06/07/24.
//

import SpriteKit

class FlameNode: HeroNode {
    
    init(position: CGPoint, atlasName: String, scale: CGFloat = 1.0) {
        super.init(atlasName: atlasName, scale: scale)
        self.action = .idle
        self.direction = .left
        self.name = "Flame"
        self.position = position
        self.physicsBody?.categoryBitMask = PhysicsCategory.flame
        self.physicsBody?.isDynamic = false
        self.physicsBody?.collisionBitMask = 0b0
        self.physicsBody?.contactTestBitMask = 0b0
    }
    
    convenience init() {
        self.init(position: CGPoint(x: 0, y: 0), atlasName: "Flame", scale: 1.0)
    }
    
    required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
}
