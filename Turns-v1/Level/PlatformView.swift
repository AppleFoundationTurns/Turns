//
//  PlatformView.swift
//  Turns-v1
//
//  Created by Federico Agnello on 02/07/24.
//

import SwiftUI
import SpriteKit

struct PlatformView: View {
    @Environment(ViewModel.self) var viewModel
    @Environment(Router.self) var router
    //@Bindable var zIndex: ViewModel
    
    var PlatformScene: SKScene {
        let scene = SKScene(fileNamed: "PlatformScene")
        scene!.size = CGSize(width: 1625, height: 750)
        scene?.scaleMode = .aspectFill
        
        return scene!
    }
    
    var body: some View {
        @Bindable var mpcInterface = viewModel.mpcInterface
        @Bindable var mpcSession = viewModel.mpcInterface.mpcSession!
        
        if(mpcSession.session.connectedPeers.count == 0){
            StartView()
                .environment(router)
                .environment(viewModel)
        } else {
            ZStack{
                SpriteView(scene: PlatformScene)//, debugOptions: [.showsPhysics])
                    .edgesIgnoringSafeArea(.all)
                    .onAppear(perform: {
                        // Injection
                        ViewModelInjected.viewModel = viewModel
                    })
                WaitingView()
                    .environment(router)
                    .environment(viewModel)
                    .zIndex(viewModel.appState.isPlaying ? -1.0 : 1.0)
                TutorialView()
                    .environment(router)
                    .environment(viewModel)
                    .zIndex(viewModel.appState.isTutorialShown ? 2.0 : -2.0)
                FinalView()
                    .environment(router)
                    .environment(viewModel)
                    .zIndex(viewModel.appState.isCompletedLevel ? 3.0 : -3.0)
            }
        }
        
    }
}

//struct Platform_Previews: PreviewProvider {
//    static var previews: some View {
//        PlatformView()
//            .previewInterfaceOrientation(.landscapeRight)
//            .environment(ViewModel(mpcInterface: MPCInterface()))
//            .environment(Router())
//    }
//}
