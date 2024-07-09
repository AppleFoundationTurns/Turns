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
        } else {
            SpriteView(scene: PlatformScene)//, debugOptions: [.showsPhysics])
                .edgesIgnoringSafeArea(.all)
        }
        
    }
}

struct Platform_Previews: PreviewProvider {
    static var previews: some View {
        PlatformView()
            .previewInterfaceOrientation(.landscapeRight)
            .environment(ViewModel(mpcInterface: MPCInterface()))
            .environment(Router())
    }
}
