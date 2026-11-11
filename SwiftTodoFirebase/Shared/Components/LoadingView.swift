//
//  LoadingView.swift
//  SwiftTodoFirebase
//
//  Created by Md Sabbir Hossain on 13/11/26.
//

import SwiftUI

/// Centered spinner with an optional caption, used for loading states.
struct LoadingView: View {
    var message = "Loading…"

    var body: some View {
        VStack(spacing: 14) {
            ProgressView()
                .scaleEffect(1.2)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
        }
    }
}
