//
//  FirebaseManager.swift
//  SwiftTodoFirebase
//
//  Created by Md Sabbir Hossain on 13/11/26.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

/// Configures Firebase once at launch and exposes the shared service
/// instances used by the rest of the app.
final class FirebaseManager {
    static let shared = FirebaseManager()

    let auth: Auth
    let firestore: Firestore

    private init() {
        FirebaseApp.configure()
        auth = Auth.auth()
        firestore = Firestore.firestore()
    }

    /// Idempotent bootstrap called from the app entry point.
    static func bootstrap() {
        _ = shared
    }
}
