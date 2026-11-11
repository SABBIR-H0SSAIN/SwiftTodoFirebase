//
//  SwiftTodoFirebaseApp.swift
//  SwiftTodoFirebase
//
//  Created by Md Sabbir Hossain on 13/11/26.
//

import SwiftUI

@main
struct SwiftTodoFirebaseApp: App {
    init() {
        // Configure Firebase before any service is used.
        FirebaseManager.bootstrap()
    }

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .tint(Theme.accent)
        }
    }
}
