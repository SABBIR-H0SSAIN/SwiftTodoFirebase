//
//  FirestoreService.swift
//  SwiftTodoFirebase
//
//  Created by Md Sabbir Hossain on 13/11/26.
//

import Foundation
import FirebaseFirestore

/// Handles all Cloud Firestore operations for the signed-in user's tasks
/// stored at `users/{userId}/tasks/{taskId}`.
///
/// Real-time listeners deliver on the main queue by default, so callback
/// closures are marked `@MainActor`.
final class FirestoreService {
    private let firestore: Firestore

    init(firestore: Firestore = FirebaseManager.shared.firestore) {
        self.firestore = firestore
    }

    // MARK: - Create

    /// Saves a new task and returns it with its document ID assigned.
    func createTask(_ task: TaskModel, userID: String) async throws -> TaskModel {
        var task = task
        task.id = nil
        task.createdAt = nil // Server timestamp is written on create.
        task.updatedAt = nil

        let reference = try tasksCollection(for: userID).addDocument(from: task)
        var saved = task
        saved.id = reference.documentID
        return saved
    }

    // MARK: - Update

    /// Replaces an existing task's content and stamps `updatedAt`.
    func updateTask(_ task: TaskModel, userID: String) async throws {
        guard let id = task.id else { return }
        var task = task
        task.updatedAt = nil // Server timestamp is written on update.

        try await tasksCollection(for: userID).document(id).setData(from: task, merge: true)
    }

    /// Toggles a task's completion status and stamps `updatedAt`.
    func setCompletion(_ isCompleted: Bool, for task: TaskModel, userID: String) async throws {
        guard let id = task.id else { return }

        try await tasksCollection(for: userID).document(id).updateData([
            "isCompleted": isCompleted,
            "updatedAt": FieldValue.serverTimestamp(),
        ])
    }

    // MARK: - Delete

    /// Permanently removes a task.
    func deleteTask(_ task: TaskModel, userID: String) async throws {
        guard let id = task.id else { return }

        try await tasksCollection(for: userID).document(id).delete()
    }

    // MARK: - Read (real-time)

    /// Observes the user's tasks in real time. The listener delivers updates
    /// on the main queue.
    func observeTasks(
        userID: String,
        onChange: @escaping @MainActor ([TaskModel]) -> Void,
        onError: @escaping @MainActor (String) -> Void
    ) -> ListenerRegistration {
        tasksCollection(for: userID).addSnapshotListener { snapshot, error in
            if let error {
                onError(FirebaseErrorMapper.message(for: error))
                return
            }
            guard let snapshot else { return }

            let tasks = snapshot.documents.compactMap { try? $0.data(as: TaskModel.self) }
            onChange(tasks)
        }
    }

    // MARK: - Private

    private func tasksCollection(for userID: String) -> CollectionReference {
        firestore.collection(FirestorePath.tasks(for: userID))
    }
}
