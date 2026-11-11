//
//  AuthenticationService.swift
//  SwiftTodoFirebase
//
//  Created by Md Sabbir Hossain on 13/11/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

/// Handles all Firebase Authentication operations: registration, sign in,
/// sign out, and authentication state observation.
final class AuthenticationService {
    private let auth: Auth
    private let firestore: Firestore

    init(auth: Auth = FirebaseManager.shared.auth,
         firestore: Firestore = FirebaseManager.shared.firestore) {
        self.auth = auth
        self.firestore = firestore
    }

    /// The currently signed-in user, or `nil` when signed out.
    var currentUser: UserModel? {
        auth.currentUser.map(Self.makeUser)
    }

    /// Creates a new account and the user's profile document at `users/{uid}`.
    func register(email: String, password: String) async throws -> UserModel {
        let result = try await auth.createUser(withEmail: email, password: password)
        let user = Self.makeUser(from: result.user)

        try? await firestore.collection(FirestorePath.users)
            .document(user.id ?? "")
            .setData([
                "email": user.email,
                "createdAt": FieldValue.serverTimestamp(),
            ])
        return user
    }

    /// Signs in an existing user with email and password.
    func login(email: String, password: String) async throws -> UserModel {
        let result = try await auth.signIn(withEmail: email, password: password)
        return Self.makeUser(from: result.user)
    }

    /// Signs out the current user.
    func logout() throws {
        try auth.signOut()
    }

    /// Observes sign-in / sign-out changes and reports the mapped user.
    func observeAuthChanges(_ handler: @escaping @MainActor (UserModel?) -> Void) -> AuthStateDidChangeListenerHandle {
        auth.addStateDidChangeListener { _, user in
            DispatchQueue.main.async {
                handler(user.map(Self.makeUser))
            }
        }
    }

    private static func makeUser(from user: User) -> UserModel {
        UserModel(id: user.uid, email: user.email ?? "", createdAt: nil)
    }
}
