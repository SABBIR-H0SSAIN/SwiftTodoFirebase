//
//  TaskModel.swift
//  SwiftTodoFirebase
//
//  Created by Md Sabbir Hossain on 13/11/26.
//

import Foundation
import FirebaseFirestore

/// A single task stored at `users/{userId}/tasks/{taskId}`.
struct TaskModel: Codable, Identifiable, Equatable {
    /// Document ID.
    @DocumentID var id: String?
    var title: String
    var description: String
    var isCompleted: Bool
    @ServerTimestamp var createdAt: Timestamp?
    @ServerTimestamp var updatedAt: Timestamp?

    /// Creation date resolved from the server timestamp.
    var createdDate: Date? {
        createdAt?.dateValue()
    }
}

/// Filters available on the home screen.
enum TaskFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case today = "Today"
    case completed = "Completed"

    var id: String { rawValue }
}
