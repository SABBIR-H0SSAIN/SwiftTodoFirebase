//
//  RegisterView.swift
//  SwiftTodoFirebase
//
//  Created by Md Sabbir Hossain on 13/11/26.
//

import SwiftUI

/// Account creation screen with email, password, and confirmation.
struct RegisterView: View {
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
                        placeholder: "Password (min. 6 characters)",
                        text: $viewModel.password,
                        isSecure: true
                    )
                    .focused($focusedField, equals: .password)
                    .submitLabel(.go)
                    .onSubmit { viewModel.register() }

                    if let errorMessage = viewModel.errorMessage {
                        ErrorBanner(message: errorMessage)
                            .onTapGesture { viewModel.clearError() }
                    }

                    PrimaryButton(
                        title: "Create Account",
                        systemImage: "person.badge.plus",
                        isLoading: viewModel.isLoading,
                        isEnabled: viewModel.canRegister
                    ) {
                        focusedField = nil
                        viewModel.register()
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
        .background(Theme.background)
        .navigationTitle("")
        .toolbar(.hidden, for: .navigationBar)
        .onAppear { focusedField = .email }
    }

    // MARK: - Private

    private var header: some View {
        VStack(spacing: 14) {
            Image(systemName: "person.crop.circle.badge.plus")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 64, height: 64)
                .background(Theme.accent)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: Theme.accent.opacity(0.35), radius: 10, y: 4)

            VStack(spacing: 6) {
                Text("Create your account")
                    .font(.system(.title, design: .rounded, weight: .bold))
                Text("Start organizing your tasks in seconds.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var footer: some View {
        HStack(spacing: 4) {
            Text("Already have an account?")
                .foregroundStyle(Theme.textSecondary)
            NavigationLink("Sign In") {
                LoginView()
            }
            .font(.body.weight(.semibold))
        }
        .font(.subheadline)
    }
}
