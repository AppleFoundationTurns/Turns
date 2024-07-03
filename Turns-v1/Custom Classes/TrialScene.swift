//
//  TrialScene.swift
//  Turns-v1
//
//  Created by Giuseppe Damiata on 03/07/24.
//

import SpriteKit

class TrialScene: SKScene {
    override func didMove(to view: SKView) {
        let hero = HeroNode(atlasName: "IdleRight")
        self.addChild(hero)
    }
}
