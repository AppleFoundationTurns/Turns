//
//  MountainsBackground.swift
//  Turns-v1
//
//  Created by Giuseppe Damiata on 29/06/24.
//

import SwiftUI
import SpriteKit

struct MenuView: View {
    var startScene: SKScene {
        let scene = SKScene(fileNamed: "StartScene")
        scene!.size = CGSize(width: 1334, height: 750)
        scene?.scaleMode = .aspectFill
        
        return scene!
    }
    
    var body: some View {
        SpriteView(scene: startScene)
            .edgesIgnoringSafeArea(.all)
        
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
