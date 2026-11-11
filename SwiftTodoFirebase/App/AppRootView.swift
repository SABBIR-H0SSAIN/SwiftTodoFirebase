//
//  AppRootView.swift
//  SwiftTodoFirebase
//
//  Created by Md Sabbir Hossain on 13/11/26.
//

import SwiftUI

/// Root view that switches between the authentication flow and the home
/// screen based on the current authentication state.
struct AppRootView: View {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        Group {
            switch authViewModel.state {
            case .loading:
                LoadingView(message: "Preparing your tasks…")
            case .signedOut:
                NavigationStack {
                    LoginView()
                }
            case .signedIn(let user):
                HomeView(user: user) {
                    authViewModel.logout()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background)
        .tint(Theme.accent)
    }
}
