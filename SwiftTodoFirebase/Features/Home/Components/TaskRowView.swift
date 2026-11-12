//
//  TaskRowView.swift
//  SwiftTodoFirebase
//
//  Created by Md Sabbir Hossain on 13/11/26.
//

import SwiftUI

/// Single task card: completion checkbox, title, and description.
struct TaskRowView: View {
    let task: TaskModel
    var onToggle: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(task.isCompleted ? Theme.success : Theme.textTertiary)
                    .animation(.spring(duration: 0.25), value: task.isCompleted)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(task.isCompleted ? "Mark as pending" : "Mark as completed")

            VStack(alignment: .leading, spacing: 3) {
                Text(task.title)
                    .font(.body.weight(.medium))
                    .foregroundStyle(task.isCompleted ? Theme.textSecondary : Theme.textPrimary)
                    .strikethrough(task.isCompleted, color: Theme.textSecondary)

                if !task.description.isEmpty {
                    Text(task.description)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                        .lineLimit(2)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle(padding: 0)
    }
}
