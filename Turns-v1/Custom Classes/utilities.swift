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
    static var none: UInt32     = 0b00000
    static var hero: UInt32     = 0b00001
    static var ground: UInt32   = 0b00010
    static var flame: UInt32    = 0b00100
    static var platform: UInt32 = 0b01000
    static var all: UInt32      = UInt32.max
}
