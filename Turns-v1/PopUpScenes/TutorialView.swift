//
//  ContentView.swift
//  EndGame
//
//  Created by Paolosalvatore Piazza on 10/07/24.
//

import SwiftUI
import SpriteKit

struct TutorialView: View {
    @Environment(ViewModel.self) var viewModel
    @Environment(Router.self) var router
        var scene: SKScene {
            @Bindable var mpcInterface = viewModel.mpcInterface
            @Bindable var mpcSession = viewModel.mpcInterface.mpcSession!
            let scene = SKScene(fileNamed: "TutorialScene")
            scene!.size = CGSize(width: 1334, height: 750)
            scene?.scaleMode = .aspectFill
            return scene!
        }
    var body: some View {
        ZStack{
            SpriteView(scene: scene)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    TutorialView()
}
