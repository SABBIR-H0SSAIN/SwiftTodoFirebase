//
//  TaskFormViewModel.swift
//  SwiftTodoFirebase
//
//  Created by Md Sabbir Hossain on 13/11/26.
//

import Combine
import Foundation
import SwiftUI

/// View model for creating and editing a single task.
@MainActor
final class TaskFormViewModel: ObservableObject {
    /// Sheet presentation mode; identifies the form for `sheet(item:)`.
    enum Mode: Identifiable {
        case create
        case edit(TaskModel)

        var id: String {
            switch self {
            case .create: "create-task"
            case .edit(let task): "edit-task-\(task.id ?? "unknown")"
            }
        }

        var isEditing: Bool {
            if case .edit = self { return true }
            return false
        }
    }

    @Published var title = ""
    @Published var taskDescription = ""
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    var isEditing: Bool { mode.isEditing }

    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isLoading
    }

    private let mode: Mode
    private let userID: String
    private let firestoreService: FirestoreService

    init(mode: Mode, userID: String) {
        self.mode = mode
        self.userID = userID
        self.firestoreService = FirestoreService()

        if case .edit(let task) = mode {
            title = task.title
            taskDescription = task.description
        }
    }

    /// Validates and saves the task. Returns `true` when the sheet may dismiss.
    func save() async -> Bool {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else {
            errorMessage = "Please enter a title for your task."
            return false
        }

        isLoading = true
        defer { isLoading = false }

        do {
            switch mode {
            case .create:
                let task = TaskModel(
                    id: nil,
                    title: trimmedTitle,
                    description: taskDescription.trimmingCharacters(in: .whitespacesAndNewlines),
                    isCompleted: false,
                    createdAt: nil,
                    updatedAt: nil
                )
                _ = try await firestoreService.createTask(task, userID: userID)
            case .edit(var task):
                task.title = trimmedTitle
                task.description = taskDescription.trimmingCharacters(in: .whitespacesAndNewlines)
                try await firestoreService.updateTask(task, userID: userID)
            }
            return true
        } catch {
            errorMessage = FirebaseErrorMapper.message(for: error)
            return false
        }
    }

    func clearError() {
        errorMessage = nil
    }
}
