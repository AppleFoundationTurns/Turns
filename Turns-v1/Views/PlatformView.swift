//
//  PlatformView.swift
//  Turns-v1
//
//  Created by Federico Agnello on 02/07/24.
//

import SwiftUI
import SpriteKit

struct PlatformView: View {
    var PlatformScene: SKScene {
        let scene = SKScene(fileNamed: "PlatformScene")
        //scene!.size = CGSize(width: 1334, height: 750)
        //scene?.scaleMode = .aspectFill
        
        return scene!
    }
    
    var body: some View {
        SpriteView(scene: PlatformScene)
            .edgesIgnoringSafeArea(.all)
        
    }
}

struct Platform_Previews: PreviewProvider {
    static var previews: some View {
        PlatformView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
