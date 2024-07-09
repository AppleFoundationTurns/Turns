//
//  File.swift
//  Turn
//
//  Created by dave on 08/07/24.
//

import Foundation

@Observable
class ViewModel {
    var currentState: GameState
    var mpcInterface: MPCInterface
    
    let zeroState = GameState(username: "", peerName: "", positionX: 0.0, positionY: 0.0, collectables: [], checkpoint: 0, velocityX: 0.0, velocityY: 0.0)
    
    init(mpcInterface: MPCInterface) {
        self.currentState = zeroState
        self.mpcInterface = mpcInterface
    }
}

class ViewModelInjected {
    static var viewModel: Any = ViewModelInjected()

    private init() { }
}
