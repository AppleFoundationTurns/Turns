//
//  TrialScene.swift
//  Turns-v1
//
//  Created by Giuseppe Damiata on 03/07/24.
//

import SpriteKit

class TrialScene: SKScene, SKPhysicsContactDelegate {
    override func didMove(to view: SKView) {
        
        let sceneBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = sceneBody
        sceneBody.friction = 0
        physicsWorld.contactDelegate = self
        
        let hero = HeroNode(atlasName: "IdleRight", scale: 2)
        hero.physicsBody?.affectedByGravity = false
        self.addChild(hero)
    }
}
