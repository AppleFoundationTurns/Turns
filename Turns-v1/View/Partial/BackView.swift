//
//  BackView.swift
//  MultipeerChat
//
//  Created by Paolosalvatore on 08/07/24.
//

import SwiftUI

struct BackView: View {
    @State private var offset: CGFloat = 20
    
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
                    .offset(x: offset)
                    .onAppear(perform: {
                        withAnimation(.easeInOut.repeatForever(autoreverses: true).speed(0.5)) {
                            offset = -20
                        }
                    })
                        
                    
            }
        }
    }
}

#Preview {
    BackView()
    .previewInterfaceOrientation(.landscapeRight)}
