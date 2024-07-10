//
//  GameState.swift
//  Turn
//
//  Created by dave on 08/07/24.
//

import Foundation

struct GameState: Codable {
    
    var username: String
    var peerName: String
    
    var positionX: Float
    var positionY: Float

    var collectables: [Collectable]
    var checkpoint: Int
    
    var velocityX: Float
    var velocityY: Float
    
    var newInfo: Bool
    
    init(username: String, peerName: String, positionX: Float, positionY: Float, collectables: [Collectable], checkpoint: Int, velocityX: Float, velocityY: Float) {
        self.username = username
        self.peerName = peerName
        self.positionX = positionX
        self.positionY = positionY
        self.collectables = collectables
        self.checkpoint = checkpoint
        self.velocityX = velocityX
        self.velocityY = velocityY
        self.newInfo = false
    }
    
    static func encodeJSON(state: GameState) -> String {
        print(state)
        let jsonData = try! JSONEncoder().encode(state)
        let jsonString = String(data: jsonData, encoding: .utf8)
        
        return jsonString!
    }
    
    static func decodeJSON(json: String) -> GameState {
        let decoder = JSONDecoder()
        let gameState = try! decoder.decode(GameState.self, from: json.data(using: .utf8)!)
        print(gameState)
        
        return gameState
    }
    
    func load<T: Decodable>(json: String) -> T {
        let data: Data
        
        data = Data(base64Encoded: json)!
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self,from: data)
        } catch {
            fatalError("Couldn't parse \(json) as \(T.self):\n\(error)")
        }
    }
}

struct Collectable: Codable {
    var label: String
    var collectables: [Bool]
}
