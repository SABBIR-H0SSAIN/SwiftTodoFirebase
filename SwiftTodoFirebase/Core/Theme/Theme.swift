//
//  Theme.swift
//  SwiftTodoFirebase
//
//  Created by Md Sabbir Hossain on 13/11/26.
//

import SwiftUI

/// Central design system: colors, metrics, and reusable values so the whole
/// app stays visually consistent.
enum Theme {
    // MARK: Colors

    /// Off-white / subtle gray app background.
    static let background = Color(uiColor: .systemGroupedBackground)
    /// Card and input surface.
    static let surface = Color(uiColor: .secondarySystemGroupedBackground)
    /// Primary accent (indigo), backed by the AccentColor asset.
    static let accent = Color.accentColor
    static let textPrimary = Color(uiColor: .label)
    static let textSecondary = Color(uiColor: .secondaryLabel)
    static let textTertiary = Color(uiColor: .tertiaryLabel)
    static let separator = Color(uiColor: .separator)
    static let success = Color(uiColor: .systemGreen)
    static let warning = Color(uiColor: .systemOrange)
    static let danger = Color(uiColor: .systemRed)

    // MARK: Metrics

    static let radius: CGFloat = 14
    static let radiusSmall: CGFloat = 10
    static let padding: CGFloat = 20
    static let spacing: CGFloat = 12
}
