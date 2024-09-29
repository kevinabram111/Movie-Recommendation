//
//  movie_recommendationApp.swift
//  movie-recommendation
//
//  Created by Kevin Abram on 22/09/24.
//

import SwiftUI

@MainActor
class UserStateViewModel: ObservableObject {
    
    enum LoginState {
        case loggedIn(userId: Int)
        case loggedOut
    }
    
    @Published var loginState: LoginState = .loggedOut
}

@main
struct movie_recommendationApp: App {
    
    @StateObject var userStateViewModel = UserStateViewModel()
    
    init() {
        if let image = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal) {
            UINavigationBar.appearance().backIndicatorImage = image
            UINavigationBar.appearance().backIndicatorTransitionMaskImage = image
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ApplicationSwitcher()
            }
            .navigationViewStyle(.stack)
            .environmentObject(userStateViewModel)
        }
    }
}

struct ApplicationSwitcher: View {
    
    @EnvironmentObject var vm: UserStateViewModel
    
    var body: some View {
        switch vm.loginState {
        case .loggedIn(let userId):
            ContentView(userId: userId)
        case .loggedOut:
            LoginView()
        }
    }
}
