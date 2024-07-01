//
//  MovementView.swift
//  Turns-v1
//
//  Created by Giuseppe Damiata on 30/06/24.
//

import SwiftUI
import SpriteKit

struct MovementView: View {
    var movementScene: SKScene {
        let scene = SKScene(fileNamed: "MovementScene")
        scene!.size = CGSize(width: 1334, height: 750)
        scene?.scaleMode = .aspectFill
        
        return scene!
    }
    
    var body: some View {
        SpriteView(scene: movementScene)
            .edgesIgnoringSafeArea(.all)
        
    }
}

struct Movement_Previews: PreviewProvider {
    static var previews: some View {
        MovementView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
