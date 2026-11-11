//
//  UserModel.swift
//  SwiftTodoFirebase
//
//  Created by Md Sabbir Hossain on 13/11/26.
//

import Foundation
import FirebaseFirestore

/// Signed-in user profile stored at `users/{userId}`.
struct UserModel: Codable, Identifiable {
    /// Document ID (equal to the Firebase Auth user ID).
    @DocumentID var id: String?
    let email: String
    @ServerTimestamp var createdAt: Timestamp?

    /// Friendly name derived from the email address, e.g. "jane.doe@…" → "Jane.doe".
    var displayName: String {
        let prefix = email.split(separator: "@").first.map(String.init) ?? email
        return prefix.prefix(1).capitalized + prefix.dropFirst()
    }
}
