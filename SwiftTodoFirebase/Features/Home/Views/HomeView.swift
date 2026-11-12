//
//  HomeView.swift
//  SwiftTodoFirebase
//
//  Created by Md Sabbir Hossain on 13/11/26.
//

import SwiftUI

/// Main task list screen: greeting, stats, filters, and the task list.
struct HomeView: View {
    let user: UserModel
    let onLogout: () -> Void

    @StateObject private var viewModel = HomeViewModel()
    @State private var formMode: TaskFormViewModel.Mode?
    @State private var taskToDelete: TaskModel?

    var body: some View {
        NavigationStack {
            content
                .background(Theme.background)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: onLogout) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundStyle(Theme.textSecondary)
                        }
                        .accessibilityLabel("Log out")
                    }
                }
                .overlay(alignment: .bottomTrailing) { addButton }
        }
        .onAppear { viewModel.startObserving(userID: user.id ?? "") }
        .onDisappear { viewModel.stopObserving() }
        .sheet(item: $formMode) { mode in
            TaskFormView(mode: mode, userID: user.id ?? "")
        }
        .confirmationDialog(
            "Delete Task",
            isPresented: Binding(
                get: { taskToDelete != nil },
                set: { if !$0 { taskToDelete = nil } }
            ),
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                if let taskToDelete {
                    viewModel.delete(taskToDelete)
                }
                self.taskToDelete = nil
            }
            Button("Cancel", role: .cancel) {
                taskToDelete = nil
            }
        } message: {
            Text("\u{201C}\(taskToDelete?.title ?? "")\u{201D} will be permanently removed from your account.")
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

    // MARK: - Content

    private var content: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 16) {
                GreetingHeader(
                    user: user,
                    total: viewModel.totalTasks,
                    completed: viewModel.completedTasks,
                    pending: viewModel.pendingTasks
                )
                FilterBar(selection: $viewModel.selectedFilter)
            }
            .padding(.horizontal, Theme.padding)
            .padding(.top, 8)

            if viewModel.isLoading && viewModel.tasks.isEmpty {
                Spacer()
                LoadingView(message: "Loading your tasks…")
                Spacer()
            } else if viewModel.filteredTasks.isEmpty {
                ScrollView {
                    HomeEmptyState(filter: viewModel.selectedFilter)
                        .padding(.top, 32)
                }
            } else {
                taskList
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    private var taskList: some View {
        List {
            ForEach(viewModel.filteredTasks) { task in
                TaskRowView(task: task) {
                    viewModel.toggle(task)
                }
                .listRowInsets(EdgeInsets(top: 5, leading: Theme.padding, bottom: 5, trailing: Theme.padding))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    formMode = .edit(task)
                }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button {
                        viewModel.toggle(task)
                    } label: {
                        Label(
                            task.isCompleted ? "Undo" : "Done",
                            systemImage: task.isCompleted ? "arrow.uturn.backward" : "checkmark"
                        )
                    }
                    .tint(Theme.success)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        taskToDelete = task
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
        .listRowSpacing(6)
        .scrollContentBackground(.hidden)
    }

    private var addButton: some View {
        Button {
            formMode = .create
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(Theme.accent)
                .clipShape(Circle())
                .shadow(color: Theme.accent.opacity(0.35), radius: 10, y: 4)
        }
        .padding(.trailing, 20)
        .padding(.bottom, 28)
        .accessibilityLabel("Add task")
    }
}
