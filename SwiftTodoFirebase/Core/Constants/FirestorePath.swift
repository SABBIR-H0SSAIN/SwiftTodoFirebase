//
//  FirestorePath.swift
//  SwiftTodoFirebase
//
//  Created by Md Sabbir Hossain on 13/11/26.
//

import Foundation

/// Firestore collection paths.
///
/// Data model: `users/{userId}/tasks/{taskId}` — every user owns a private
/// task subcollection, enforced by security rules.
enum FirestorePath {
    static let users = "users"

    static func tasks(for userID: String) -> String {
        "\(users)/\(userID)/tasks"
    }
}
