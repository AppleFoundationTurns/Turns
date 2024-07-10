//
//  WaitingView.swift
//  Turns-v1
//
//  Created by Paolosalvatore on 10/07/24.
//

import SwiftUI

struct SpinningDude: View {
    /*#-code-walkthrough(2.spinningAnimation)*/
    @State private var width: CGFloat = 1
    @State private var color: Int = 0
    /*#-code-walkthrough(2.spinningAnimation)*/
    
    var body: some View {
        //var size: CGFloat = 70
        @State var offset: CGFloat = 20
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

struct WaitingView: View {
    
    @State private var isSpinning = true
    @State private var offset: CGFloat = 20
    var size: CGFloat = 70
    
    @Environment(ViewModel.self) var viewModel
    @Environment(Router.self) var router
    
    var body: some View {
        ZStack{
            BackView()
            
            VStack {
                
                
                Image("shadowedLogo")
                    .resizable()
                    .frame(width: 1000 * 0.3, height: 426 * 0.3)
                    .aspectRatio(contentMode: .fit)
                    .position(x: (1334 / 4)+25, y: (750 / 4) - 130)
                    .shadow(color: .black, radius: 5)
                
                
                
                
                HStack{
                    
                    Text("Waiting   for   your ")
                        .font(.custom("ArcadeClassic", size: 50))
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    
                    Text("TURN")
                        .font(.custom("ArcadeClassic", size: 50))
                        .foregroundColor(Color(hex: 0xEF8540))
                        .shadow(color: .black, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                }.position(x: (1334 / 4)+25, y: (750 / 4) - 110)
                

              SpinningDude()
                
            } .padding()
        }
    }
}
    
    #Preview {
        WaitingView()
            .previewInterfaceOrientation(.landscapeRight)
            .environment(ViewModel(mpcInterface: MPCInterface()))
            .environment(Router())
    }

