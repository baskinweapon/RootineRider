//
//  Untitled.swift
//  RoutineRider
//
//  Created by Aleksandr Baskin on 13/09/2024.
//

import SwiftUICore

public class CompetitionInfo {
    public static func taskCompletionDescriptionColor(count: Int ) -> Color {
        switch count {
        case 0...2:
            return Color.blue.opacity(0.2)
        case 3...4:
            return .red.opacity(0.2)
        case 5...7:
            return .yellow.opacity(0.2)
        case 8...9:
            return .green.opacity(0.2)
        default:
            return .green.opacity(0.2)
        }
    }
    
    public static func taskCompletionDescription(count: Int) -> String {
        switch count {
        case 0:
            return "Worst"
        case 1...2:
            return "Poor"
        case 3...4:
            return "Average"
        case 5...7:
            return "Good"
        case 8...9:
            return "Awesome"
        case 10...100:
            return "Excellent"
        default:
            return "Unknown"
        }
    }
    
    public static func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}
