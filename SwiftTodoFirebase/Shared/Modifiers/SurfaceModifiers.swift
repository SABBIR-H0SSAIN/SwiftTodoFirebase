//
//  SurfaceModifiers.swift
//  SwiftTodoFirebase
//
//  Created by Md Sabbir Hossain on 13/11/26.
//

import SwiftUI

extension View {
    /// Elevated white card surface with consistent radius and shadow.
    func cardStyle(padding: CGFloat = 14, radius: CGFloat = Theme.radius) -> some View {
        self
            .padding(padding)
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }

    /// Bordered input surface without elevation.
    func fieldStyle(radius: CGFloat = Theme.radius) -> some View {
        self
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(Theme.separator.opacity(0.6), lineWidth: 1)
            )
    }
}
