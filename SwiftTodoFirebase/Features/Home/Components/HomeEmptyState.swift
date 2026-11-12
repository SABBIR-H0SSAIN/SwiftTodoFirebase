//
//  HomeEmptyState.swift
//  SwiftTodoFirebase
//
//  Created by Md Sabbir Hossain on 13/11/26.
//

import SwiftUI

/// Friendly empty state shown when the filtered task list has no items.
struct HomeEmptyState: View {
    let filter: TaskFilter

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.system(size: 42, weight: .light))
                .foregroundStyle(Theme.textTertiary)

            Text(title)
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Theme.padding)
        .padding(.vertical, 48)
    }

    private var iconName: String {
        switch filter {
        case .all: "tray"
        case .today: "calendar"
        case .completed: "checkmark.seal"
        }
    }

    private var title: String {
        switch filter {
        case .all: "No tasks yet"
        case .today: "Nothing for today"
        case .completed: "All caught up!"
        }
    }

    private var message: String {
        switch filter {
        case .all:
            "Tap the + button to add your first task and start organizing your day."
        case .today:
            "Tasks you add today will show up here until they're done."
        case .completed:
            "Tasks you complete will be collected here. Keep it up!"
        }
    }
}
