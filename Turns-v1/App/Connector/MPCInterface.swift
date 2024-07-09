//
//  MPCInterface.swift
//  MultipeerChat
//
//  Created by dave on 05/07/24.
//

import Foundation
import MultipeerConnectivity
import SwiftUI

protocol Connectivity {
    func initImpl(username: String, viewModel: ViewModel) -> Void
    func isPaired() -> Bool
    func getUsername() -> String
    func sendState() -> Void
    //func recvState() -> GameState
    func disconnect() -> Void
}

@Observable 
class MPCInterface: Connectivity {
    
   var mpcSession: MPCImpl?
    
    func initImpl(username: String, viewModel: ViewModel) -> Void {
       mpcSession = MPCImpl(username: username, viewModel: viewModel)
    }
    
    func Catchable(f: () throws -> ()) -> Bool {
        do{
            try f()
            return true
        } catch let error {
            print(error)
            return false
        }
    }
    
    func isPaired() -> Bool {
        return mpcSession!.paired
    }
    
    func getUsername() -> String {
        return mpcSession!.username
    }
    
    func sendState() -> Void {
        mpcSession!.send()
    }
    
    /*
    func recvState() -> GameState {
        return GameState(idMPC: mpcSession!.myPeerID, payload: mpcSession!.receivedState)
    }
     */
    
    func disconnect() -> Void {
        mpcSession!.session.disconnect()
    }
}
