//
//  HomeViewModel.swift
//  SwiftTodoFirebase
//
//  Created by Md Sabbir Hossain on 13/11/26.
//

import Combine
import Foundation
import SwiftUI
import FirebaseFirestore

/// View model for the home screen. Streams the user's tasks in real time and
/// exposes filtered lists and summary counts.
@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var tasks: [TaskModel] = []
    @Published private(set) var isLoading = true
    @Published var errorMessage: String?
    @Published var selectedFilter: TaskFilter = .all

    private var listener: ListenerRegistration?
    private var userID: String?
    private let firestoreService = FirestoreService()

    // MARK: - Real-time observation

    /// Starts (or restarts) the real-time task stream for the given user.
    func startObserving(userID: String) {
        guard !userID.isEmpty, userID != self.userID else { return }
        stopObserving()

        self.userID = userID
        isLoading = true

        listener = firestoreService.observeTasks(
            userID: userID,
            onChange: { [weak self] tasks in
                self?.tasks = self?.sorted(tasks) ?? tasks
                self?.isLoading = false
            },
            onError: { [weak self] message in
                self?.errorMessage = message
                self?.isLoading = false
            }
        )
    }

    func stopObserving() {
        listener?.remove()
        listener = nil
    }

    // MARK: - Derived state

    /// Tasks matching the selected filter, ready for display.
    var filteredTasks: [TaskModel] {
        switch selectedFilter {
        case .all:
            tasks
        case .today:
            // Tasks added today that still need to be done.
            tasks.filter { task in
                guard !task.isCompleted, let date = task.createdDate else { return false }
                return Calendar.current.isDateInToday(date)
            }
        case .completed:
            tasks.filter(\.isCompleted)
        }
    }

    var totalTasks: Int { tasks.count }
    var completedTasks: Int { tasks.filter(\.isCompleted).count }
    var pendingTasks: Int { tasks.count - completedTasks }

    // MARK: - Actions

    /// Toggles completion; the real-time listener refreshes the list.
    func toggle(_ task: TaskModel) {
        guard let userID else { return }
        Task {
            do {
                try await firestoreService.setCompletion(!task.isCompleted, for: task, userID: userID)
            } catch {
                errorMessage = FirebaseErrorMapper.message(for: error)
            }
        }
    }

    /// Deletes a task; the real-time listener refreshes the list.
    func delete(_ task: TaskModel) {
        guard let userID else { return }
        Task {
            do {
                try await firestoreService.deleteTask(task, userID: userID)
            } catch {
                errorMessage = FirebaseErrorMapper.message(for: error)
            }
        }
    }

    func clearError() {
        errorMessage = nil
    }

    // MARK: - Private

    /// Pending tasks first, newest on top within each group.
    private func sorted(_ tasks: [TaskModel]) -> [TaskModel] {
        tasks.sorted { lhs, rhs in
            if lhs.isCompleted != rhs.isCompleted {
                return !lhs.isCompleted
            }
            let lhsDate = lhs.createdDate ?? .distantPast
            let rhsDate = rhs.createdDate ?? .distantPast
            return lhsDate > rhsDate
        }
    }
}
