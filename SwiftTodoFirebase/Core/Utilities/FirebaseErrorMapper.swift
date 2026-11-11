//
//  FirebaseErrorMapper.swift
//  SwiftTodoFirebase
//
//  Created by Md Sabbir Hossain on 13/11/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

/// Maps raw Firebase errors into short, user-facing messages.
enum FirebaseErrorMapper {
    static func message(for error: Error) -> String {
        let nsError = error as NSError

        if nsError.domain == AuthErrorDomain, let code = AuthErrorCode(rawValue: nsError.code) {
            return authMessage(for: code)
        }
        if nsError.domain == FirestoreErrorDomain, let code = FirestoreErrorCode.Code(rawValue: nsError.code) {
            return firestoreMessage(for: code)
        }
        return error.localizedDescription
    }

    private static func authMessage(for code: AuthErrorCode) -> String {
        switch code {
        case .invalidEmail:
            "Please enter a valid email address."
        case .wrongPassword, .invalidCredential:
            "Incorrect email or password. Please try again."
        case .userNotFound:
            "No account found with this email address."
        case .userDisabled:
            "This account has been disabled."
        case .emailAlreadyInUse:
            "An account already exists with this email address."
        case .weakPassword:
            "Your password is too weak. Use at least 6 characters."
        case .tooManyRequests:
            "Too many attempts. Please try again later."
        case .networkError:
            "No internet connection. Please try again."
        default:
            "Authentication failed. Please try again."
        }
    }

    private static func firestoreMessage(for code: FirestoreErrorCode.Code) -> String {
        switch code {
        case .permissionDenied:
            "You don't have permission to access your tasks. Check your Firestore rules."
        case .unavailable:
            "The service is temporarily unavailable. Please try again."
        case .deadlineExceeded:
            "The request took too long. Please try again."
        default:
            "Couldn't sync your tasks. Please try again."
        }
    }
}
