//
//  EntryView.swift
//  Turns-v1
//
//  Created by Giuseppe Damiata on 29/06/24.
//

import SwiftUI
import SpriteKit

struct MenuView: View {
    var menuScene: SKScene {
        let scene = SKScene(fileNamed: "MenuScene")
        scene!.size = CGSize(width: 1334, height: 750)
        scene?.scaleMode = .aspectFill
        
        return scene!
    }
    
    var body: some View {
        SpriteView(scene: menuScene)
            .edgesIgnoringSafeArea(.all)
        
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
