//
//  utilities.swift
//  Turns-v1
//
//  Created by Giuseppe Damiata on 06/07/24.
//

import SpriteKit

enum Action {
    case idle
    case move
    case jump
}

enum Direction {
    case right
    case left
}

struct Animation {
    var idle: [SKTexture]
    var jump: [SKTexture]
    var run: [SKTexture]
    init(idle: [SKTexture], jump: [SKTexture], run: [SKTexture]) {
        self.idle = idle
        self.jump = jump
        self.run = run
    }
}

struct PhysicsCategory{
    static var none: UInt32             = 0b00000000
    static var blueHero: UInt32         = 0b00000001
    static var orangeHero: UInt32       = 0b00000011
    static var ground: UInt32           = 0b00000100
    static var flame: UInt32            = 0b00001000
    static var bluePlatform: UInt32     = 0b00010000
    static var orangePlatform: UInt32   = 0b00100000
    static var blueFruit: UInt32        = 0b01000000
    static var orangeFruit: UInt32      = 0b10000000
    static var all: UInt32              = UInt32.max
    static var flameBackup: UInt32            = 0b00001000
}
