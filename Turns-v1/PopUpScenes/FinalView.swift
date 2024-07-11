//
//  FinalView.swift
//  EndGame
//
//  Created by Alberto Scannaliato on 10/07/24.
//

import SwiftUI
import SpriteKit

struct FinalView: View {
    @Environment(ViewModel.self) var viewModel
    @Environment(Router.self) var router
        var scene: SKScene {
            let scene = SKScene(fileNamed: "FinalScene")
            scene!.size = CGSize(width: 1334, height: 750)
            scene?.scaleMode = .aspectFill
            return scene!
        }
    var body: some View {
        @Bindable var mpcInterface = viewModel.mpcInterface
        @Bindable var mpcSession = viewModel.mpcInterface.mpcSession!
        SpriteView(scene: scene)
            .edgesIgnoringSafeArea(.all)
            .onAppear(perform: {
                // Injection
                ViewModelInjected.viewModel = viewModel
            })
    }
}

#Preview {
    FinalView()
}
