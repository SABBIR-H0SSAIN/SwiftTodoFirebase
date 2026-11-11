//
//  Date+Format.swift
//  SwiftTodoFirebase
//
//  Created by Md Sabbir Hossain on 13/11/26.
//

import Foundation

extension Date {
    /// "Friday, 13 November" style string for the home header.
    var headerDateText: String {
        Self.headerFormatter.string(from: self)
    }

    /// Time-of-day based greeting, e.g. "Good morning".
    var greetingTimeOfDay: String {
        switch Calendar.current.component(.hour, from: self) {
        case 5..<12: "Good morning"
        case 12..<17: "Good afternoon"
        default: "Good evening"
        }
    }

    private static let headerFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEE, d MMMM")
        return formatter
    }()
}
