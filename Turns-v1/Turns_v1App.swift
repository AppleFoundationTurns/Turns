//
//  Turns_v1App.swift
//  Turns-v1
//
//  Created by Giuseppe Damiata on 28/06/24.
//

import SwiftUI

@main
struct Turns_v1App: App {
    var mpcInterface: MPCInterface = MPCInterface()
    
    var body: some Scene {
        WindowGroup {
            RouterView()
                .environment(mpcInterface)
                .environment(ViewModel(mpcInterface: mpcInterface))
        }
    }
}
