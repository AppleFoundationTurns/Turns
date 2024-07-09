//
//  StartView.swift
//  MultipeerChat
//
//  Created by dave on 05/07/24.
//

import SwiftUI

struct StartView: View {
    
    @Environment(ViewModel.self) var viewModel
    @Environment(Router.self) var router
    
    @State var username = ""
    
    var body: some View {
        @Bindable var mpcInterface = viewModel.mpcInterface
        ZStack{
            BackView().aspectRatio(contentMode: .fill)
            VStack {
                HStack {
                    Text("Enter a nickname below. Choose something your friend will recognize!")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 40)
                        .multilineTextAlignment(.center)
                }
                HStack {
                    TextField("Nickname", text: $username)
                        .padding([.horizontal], 75.0)
                        .padding(.bottom, 24)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack {
                    Button("Continue →") {
                        mpcInterface.initImpl(username: username, viewModel: viewModel)
                        router.navigateTo(route: .pairView)
                        //currentView = 1
                    }.buttonStyle(BorderlessButtonStyle())
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                        .foregroundColor(.white)
                        .background(Color(hex: 0xEF8540, alpha: 1.0))
                        .cornerRadius(12)
                        .disabled(username.isEmpty ? true : false)
                }
                HStack {
                    Spacer()
                }
            }
        }
    }
}
