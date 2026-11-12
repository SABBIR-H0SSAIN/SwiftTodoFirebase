//
//  FilterBar.swift
//  SwiftTodoFirebase
//
//  Created by Md Sabbir Hossain on 13/11/26.
//

import SwiftUI

/// Horizontal filter pill selector for the task list.
struct FilterBar: View {
    @Binding var selection: TaskFilter

    var body: some View {
        HStack(spacing: 8) {
            ForEach(TaskFilter.allCases) { filter in
                filterPill(for: filter)
            }
            Spacer(minLength: 0)
        }
    }

    private func filterPill(for filter: TaskFilter) -> some View {
        let isSelected = selection == filter

        return Button {
            withAnimation(.spring(duration: 0.25)) {
                selection = filter
            }
        } label: {
            Text(filter.rawValue)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? Theme.accent : Theme.surface)
                .foregroundStyle(isSelected ? Color.white : Theme.textSecondary)
                .clipShape(Capsule())
                .overlay(
                    Capsule().strokeBorder(
                        isSelected ? .clear : Theme.separator.opacity(0.6),
                        lineWidth: 1
                    )
                )
        }
        .buttonStyle(.plain)
    }
}
