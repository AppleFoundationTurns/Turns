//
//  BackView.swift
//  MultipeerChat
//
//  Created by Paolosalvatore on 08/07/24.
//

import SwiftUI

struct BackView: View {
    @State private var moveRight = false
    
    var body: some View {
        GeometryReader{_ in
            ZStack{
                Image("sky2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                Image("clouds3")
                    .resizable()
                    .interpolation(.none)
                    .aspectRatio(contentMode: .fit)
                    .offset(x: moveRight ? 20 : -20)
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true))
                    .onAppear {self.moveRight.toggle()
                        
                    }
            }
        }
    }
}

#Preview {
    BackView()
    .previewInterfaceOrientation(.landscapeRight)}
