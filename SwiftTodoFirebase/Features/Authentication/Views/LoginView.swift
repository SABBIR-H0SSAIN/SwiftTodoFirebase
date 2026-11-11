//
//  LoginView.swift
//  SwiftTodoFirebase
//
//  Created by Md Sabbir Hossain on 13/11/26.
//

import SwiftUI

/// Sign-in screen with email and password.
struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @FocusState private var focusedField: Field?

    private enum Field {
        case email, password
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                header

                VStack(spacing: 14) {
                    AuthTextField(
                        icon: "envelope",
                        placeholder: "Email",
                        text: $viewModel.email
                    )
                    .focused($focusedField, equals: .email)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .password }

                    AuthTextField(
                        icon: "lock",
                        placeholder: "Password",
                        text: $viewModel.password,
                        isSecure: true
                    )
                    .focused($focusedField, equals: .password)
                    .submitLabel(.go)
                    .onSubmit { viewModel.login() }

                    if let errorMessage = viewModel.errorMessage {
                        ErrorBanner(message: errorMessage)
                            .onTapGesture { viewModel.clearError() }
                    }

                    PrimaryButton(
                        title: "Sign In",
                        systemImage: "arrow.right.to.line",
                        isLoading: viewModel.isLoading,
                        isEnabled: viewModel.canLogin
                    ) {
                        focusedField = nil
                        viewModel.login()
                    }
                }

                Spacer(minLength: 8)

                footer
            }
            .padding(.horizontal, Theme.padding)
            .padding(.top, 60)
            .padding(.bottom, 24)
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationBarHidden(true)
        .background(Theme.background)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear { focusedField = .email }
    }

    // MARK: - Private

    private var header: some View {
        VStack(spacing: 14) {
            Image(systemName: "checkmark")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 64, height: 64)
                .background(Theme.accent)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: Theme.accent.opacity(0.35), radius: 10, y: 4)

            VStack(spacing: 6) {
                Text("Welcome back")
                    .font(.system(.title, design: .rounded, weight: .bold))
                Text("Sign in to manage your tasks.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var footer: some View {
        HStack(spacing: 4) {
            Text("Don't have an account?")
                .foregroundStyle(Theme.textSecondary)
            NavigationLink("Sign Up") {
                RegisterView()
            }
            .font(.body.weight(.semibold))
        }
        .font(.subheadline)
    }
}

/// Red-tinted rounded banner for validation and Firebase errors.
struct ErrorBanner: View {
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundStyle(Theme.danger)
            Text(message)
                .font(.footnote)
                .foregroundStyle(Theme.danger)
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(Theme.danger.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: Theme.radiusSmall, style: .continuous))
    }
}
