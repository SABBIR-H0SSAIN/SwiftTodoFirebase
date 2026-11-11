//
//  AuthViewModel.swift
//  SwiftTodoFirebase
//
//  Created by Md Sabbir Hossain on 13/11/26.
//

import Combine
import Foundation
import SwiftUI

/// Authentication flow state consumed by the root view.
enum AuthState {
    case loading
    case signedOut
    case signedIn(UserModel)
}

/// View model for the authentication screens. Owns form fields, validation,
/// loading/error state, and the authentication lifecycle.
@MainActor
final class AuthViewModel: ObservableObject {
    @Published private(set) var state: AuthState = .loading

    @Published var email = ""
    @Published var password = ""
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let authService: AuthenticationService

    init(authService: AuthenticationService = AuthenticationService()) {
        self.authService = authService

        // Resolve the persisted session immediately, then keep observing.
        state = authService.currentUser.map { .signedIn($0) } ?? .signedOut

        authService.observeAuthChanges { [weak self] user in
            withAnimation(.easeInOut(duration: 0.25)) {
                self?.state = user.map { .signedIn($0) } ?? .signedOut
            }
        }
    }

    // MARK: - Validation

    private var trimmedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var canLogin: Bool {
        !trimmedEmail.isEmpty && !password.isEmpty && !isLoading
    }

    var canRegister: Bool {
        isValidEmail(trimmedEmail)
            && password.count >= 6
            && !isLoading
    }

    // MARK: - Actions

    func login() {
        guard !trimmedEmail.isEmpty else {
            errorMessage = "Please enter your email address."
            return
        }
        guard !password.isEmpty else {
            errorMessage = "Please enter your password."
            return
        }
        perform { try await self.authService.login(email: self.trimmedEmail, password: self.password) }
    }

    func register() {
        guard isValidEmail(trimmedEmail) else {
            errorMessage = "Please enter a valid email address."
            return
        }
        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters."
            return
        }
        perform { try await self.authService.register(email: self.trimmedEmail, password: self.password) }
    }

    func logout() {
        try? authService.logout()
    }

    func clearError() {
        errorMessage = nil
    }

    // MARK: - Private

    private func perform(_ operation: @escaping () async throws -> UserModel) {
        isLoading = true
        Task {
            defer { isLoading = false }
            do {
                // The auth listener updates `state` on success.
                _ = try await operation()
            } catch {
                errorMessage = FirebaseErrorMapper.message(for: error)
            }
        }
    }

    private func isValidEmail(_ value: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: value)
    }
}
