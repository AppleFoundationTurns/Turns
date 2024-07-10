//
//  PairView.swift
//  MultipeerChat
//
//  Created by dave on 05/07/24.
//

import SwiftUI
import os

struct PairView: View {
    
    @Environment(ViewModel.self) var viewModel
    @Environment(Router.self) var router
    
    var logger = Logger()
        
    var body: some View {
        @Bindable var mpcInterface = viewModel.mpcInterface
        @Bindable var mpcSession = viewModel.mpcInterface.mpcSession!
        ZStack{
            if(!mpcInterface.isPaired()){
                ZStack{
                    BackView().padding(.bottom, 430)//.aspectRatio(contentMode: .fill)
                    ListFriend()
                        .alert(
                            "Received an invite from \(mpcInterface.mpcSession!.recvdInviteFrom?.displayName ?? "ERR")!",
                            isPresented: $mpcSession.recvdInvite
                        ) {
                            Button("Accept") {
                                if (mpcInterface.mpcSession!.invitationHandler != nil) {
                                    mpcInterface.mpcSession!.invitationHandler!(true, mpcInterface.mpcSession!.session)
                                    
                                    viewModel.appState.isGuest = true
                                }
                            }
                            Button("Reject") {
                                if (mpcInterface.mpcSession!.invitationHandler != nil) {
                                    mpcInterface.mpcSession!.invitationHandler!(false, nil)
                                }
                            }
                        }
                    
                }
            } else {
                //SenderView(currentView: $currentView)
                PlatformView()
                    .environment(router)
                    .environment(viewModel)
            }
        }.background(.clear)
    }
}
