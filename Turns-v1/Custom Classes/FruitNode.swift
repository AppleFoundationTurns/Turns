//
//  FruitNode.swift
//  Turns-v1
//
//  Created by Giuseppe Damiata on 10/07/24.
//

import Foundation
import SpriteKit

class FruitNode : SKSpriteNode {
    var collected = false
    
    func animate() -> Void {
        let scale = SKAction.scale(by: 1.5, duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let sound = SKAction.playSoundFileNamed("", waitForCompletion: false)
        let collectSequence = SKAction.sequence([sound, scale, fadeOut])
        self.run(collectSequence)
    }
}
