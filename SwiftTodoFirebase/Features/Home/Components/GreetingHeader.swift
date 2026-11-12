//
//  GreetingHeader.swift
//  SwiftTodoFirebase
//
//  Created by Md Sabbir Hossain on 13/11/26.
//

import SwiftUI

/// Personalized greeting and current date shown at the top of the home screen.
struct GreetingHeader: View {
    let user: UserModel
    var total = 0
    var completed = 0
    var pending = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("\(Date().greetingTimeOfDay), \(user.displayName)")
                .font(.system(.title2, design: .rounded, weight: .bold))
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(Date().headerDateText)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)

            Text(summaryText)
                .font(.footnote)
                .foregroundStyle(Theme.textTertiary)
                .padding(.top, 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var summaryText: String {
        let taskWord = total == 1 ? "task" : "tasks"
        return "\(total) \(taskWord) · \(completed) completed · \(pending) pending"
    }
}
