//
//  SpinningDude.swift
//  Turns-v1
//
//  Created by Federico Agnello on 10/07/24.
//

import Foundation
import SwiftUI

struct SpinningDude: View {
    /*#-code-walkthrough(2.spinningAnimation)*/
    @State private var width: CGFloat = 1
    @State private var color: Int = 0
    /*#-code-walkthrough(2.spinningAnimation)*/
    
    var body: some View {
        //var size: CGFloat = 70
        Image(color % 2 == 0 ? "Dude" : "DudeO")
            .resizable()
            .interpolation(.none)
        //.aspectRatio(contentMode: .fit)
            .frame(width: 70, height: 70)
            .scaleEffect(CGSize(width: width, height: 1))
        //.cornerRadius(width / 2)
            .position(x: (1334 / 4)+25, y: (750 / 4) - 130)
            .onAppear {
                withAnimation(.easeInOut.repeatForever(autoreverses: true).speed(0.2)) {
                    width = -1
                    color = 1
                }
            }
        
    }
}

//struct Spinning_Previews: PreviewProvider {
//    static var previews: some View {
//        SpinningDude()
//    }
//}
