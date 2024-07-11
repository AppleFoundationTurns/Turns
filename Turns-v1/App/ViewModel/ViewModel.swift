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
    var appState: AppState
    var mpcInterface: MPCInterface
    
    let zeroState = GameState(username: "", peerName: "", positionX: 0.0, positionY: 0.0, collectables: [], checkpoint: 0, velocityX: 0.0, velocityY: 0.0)
    
    let zeroAppState = AppState(isGuest: false, isPlaying: false, isTutorialShown: true, isCompletedLevel: false)
    
    init(mpcInterface: MPCInterface) {
        self.currentState = zeroState
        self.appState = AppState(isGuest: false, isPlaying: true, isTutorialShown: true, isCompletedLevel: false)
        self.mpcInterface = mpcInterface
    }
    
    func resetState() {
        self.appState = zeroAppState
        self.currentState = zeroState
    }
}

class ViewModelInjected {
    static var viewModel: Any = ViewModelInjected()

    private init() { }
}
