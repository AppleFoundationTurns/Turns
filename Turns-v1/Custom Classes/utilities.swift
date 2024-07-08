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

struct PhysicsCategory{
    static var none: UInt32             = 0b000000
    static var hero: UInt32             = 0b000001
    static var ground: UInt32           = 0b000010
    static var flame: UInt32            = 0b000100
    static var bluePlatform: UInt32     = 0b001000
    static var orangePlatform: UInt32   = 0b010000
    static var all: UInt32              = UInt32.max
}
