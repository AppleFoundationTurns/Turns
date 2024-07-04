//
//  TrialView.swift
//  Turns-v1
//
//  Created by Giuseppe Damiata on 30/06/24.
//

import SwiftUI
import SpriteKit

struct TrialView: View {
    var trialScene: SKScene {
        let scene = SKScene(fileNamed: "TrialScene")
        scene!.size = CGSize(width: 1334, height: 750)
        scene?.scaleMode = .aspectFill
        
        return scene!
    }
    
    var body: some View {
        SpriteView(scene: trialScene, debugOptions: [.showsPhysics])
            .edgesIgnoringSafeArea(.all)
        
    }
}

struct Trial_Previews: PreviewProvider {
    static var previews: some View {
        TrialView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
