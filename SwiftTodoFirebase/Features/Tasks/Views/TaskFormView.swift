//
//  TaskFormView.swift
//  SwiftTodoFirebase
//
//  Created by Md Sabbir Hossain on 13/11/26.
//

import SwiftUI

/// Sheet for creating or editing a task: title (required) and optional notes.
struct TaskFormView: View {
    @StateObject private var viewModel: TaskFormViewModel
    @Environment(\.dismiss) private var dismiss

    init(mode: TaskFormViewModel.Mode, userID: String) {
        _viewModel = StateObject(wrappedValue: TaskFormViewModel(mode: mode, userID: userID))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.spacing) {
                    TextField("Task title", text: $viewModel.title)
                        .font(.system(.title3, design: .rounded, weight: .semibold))
                        .padding(14)
                        .fieldStyle()
                        .submitLabel(.next)

                    VStack(alignment: .leading, spacing: 6) {
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $viewModel.taskDescription)
                                .frame(minHeight: 130)
                                .scrollContentBackground(.hidden)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 8)

                            if viewModel.taskDescription.isEmpty {
                                Text("Add notes (optional)…")
                                    .foregroundStyle(Theme.textTertiary)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 16)
                                    .allowsHitTesting(false)
                            }
                        }
                        .fieldStyle(radius: Theme.radiusSmall)
                    }
                }
                .padding(Theme.padding)
            }
            .scrollDismissesKeyboard(.interactively)
            .background(Theme.background)
            .navigationTitle(viewModel.isEditing ? "Edit Task" : "New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    saveButton
                }
            }
            .alert(
                "Something went wrong",
                isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { if !$0 { viewModel.clearError() } }
                )
            ) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
        .presentationDetents([.medium, .large])
    }

    private var saveButton: some View {
        Button {
            Task {
                let saved = await viewModel.save()
                if saved {
                    dismiss()
                }
            }
        } label: {
            if viewModel.isLoading {
                ProgressView()
            } else {
                Text("Save")
                    .font(.body.weight(.semibold))
            }
        }
        .disabled(!viewModel.canSave)
    }
}
