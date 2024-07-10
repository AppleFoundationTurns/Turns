//
//  ListPlayer.swift
//  MultipeerChat
//
//  Created by dave on 05/07/24.
//

import SwiftUI

struct ListFriend: View {
    
    @Environment(MPCInterface.self) var mpcInterface
    
    var size: CGFloat = 50
    
    var body: some View {
        @Bindable var mpcInterface = mpcInterface
        @Bindable var mpcSession = mpcInterface.mpcSession!
        HStack {
            Spacer()
        }
        /*HStack {
                HStack {
                    HStack {
                        Text(mpcInterface.getUsername())
                            .font(.system(size: 18))
                            .foregroundStyle(.white)
                    }
                    .padding(.all, 7)
                }
                .frame(width: 150, height: 30)
                .foregroundColor(.white)
                .background(.green)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.green, lineWidth: 1.5)
                    
                ).onTapGesture {
                   
                }
            
        }*/
        HStack {
            Spacer()
        }
        HStack {
            //NavigationSplitView {
                List(mpcSession.availablePeers, id: \.self) { peer in
                    Button{
                        mpcInterface.mpcSession!.serviceBrowser.invitePeer(peer, to: mpcInterface.mpcSession!.session, withContext: nil, timeout: 30)
                    }
                    label: {
                        HStack{
                            
                            Image((Int.random(in: 0...1)) % 2 == 0 ? "Dude" : "DudeO")
                                .resizable()
                                .interpolation(.none)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: size, height: size)
                                .background(Color.blue)
                                .cornerRadius(size / 2)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 4)
                                        .frame(width: size, height: size)
                                        
                                )
                                .shadow(radius: 10)
                             
                            Text(peer.displayName)
                                .padding()
                                
                                
                        }
                    }
                    .listRowBackground(Color.orange)
                    .listRowSeparatorTint(.blue)
                }
                .navigationTitle(mpcInterface.getUsername())
                .scrollContentBackground(.hidden)
            //} detail: {
            //    Text("Select a Friend")
            //}
        }.tint(.blue)
    }
}

#Preview {
    ListFriend()
        .environment(MPCInterface())
}
