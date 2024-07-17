//
//  ContentView.swift
//  Entry
//
//  Created by Paolosalvatore on 09/07/24.
//

import SwiftUI

struct EntryView: View {
    
    @Environment(ViewModel.self) var viewModel
    @Environment(Router.self) var router
    
    var body: some View {
        ZStack{
            BackView()
            
            VStack {
                
                Text("Turns")
                    .font(.custom("ArcadeClassic", size: 95))
                    .foregroundColor(Color(hex: 0xEF8540))
                    .position(x: (1334 / 4)+25, y: (750 / 6) - 90)
                    .shadow(color: .black, radius: 5)
                    .onAppear {
                        AudioManager.shared.playSound(named: AudioManager.shared.menuSoundName)
                    }
                Image("shadowedLogo")
                    .resizable()
                    .frame(width: 1000 * 0.3, height: 426 * 0.3)
                    .aspectRatio(contentMode: .fit)
                    .position(x: (1334 / 4)+25, y: (750 / 4) - 130)
                    .shadow(color: .black, radius: 5)
                
                Button(action: { router.navigateTo(route: .startView) }){
                    ZStack{
                        Image("bottone")
                            .resizable()
                            .interpolation(.none)
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        
                        HStack{
                            
                            Text("Play")
                                .font(.custom("ArcadeClassic", size: 50))
                                .foregroundColor(.black)
                            
                            Image("Play")
                                .resizable()
                                .interpolation(.none)
                                .scaledToFit()
                                .frame(width: 35, height: 35)
                        }
                    }
                    
                }.position(x: (1334 / 4)+25, y: (750 / 4) - 120)
                
            }
            .padding()
        }
    }
}

#Preview {
    EntryView()
        .previewInterfaceOrientation(.landscapeRight)
        .environment(ViewModel(mpcInterface: MPCInterface()))
        .environment(Router())
}
