//
//  ProfileView.swift
//  movie-recommendation
//
//  Created by Kevin Abram on 22/09/24.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var vm: UserStateViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    vm.loginState = .loggedOut
                    dismiss()
                }, label: {
                    Text("Sign Out")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(MovieAppColors.red)
                })
                Spacer()
            }
            Spacer()
        }
        .ignoresSafeArea()
        .background(MovieAppColors.black)
    }
}

#Preview {
    ProfileView()
}
