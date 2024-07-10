//
//  WaitingView.swift
//  Turns-v1
//
//  Created by Paolosalvatore on 10/07/24.
//

import Foundation
import SwiftUI

struct WaitingView: View {
    
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

//struct Waiting_Previews: PreviewProvider {
//    static var previews: some View {
//        WaitingView()
//        
//    }
//    //
//    //.environment(ViewModel(mpcInterface: MPCInterface()))
//    //.environment(Router())
//}

