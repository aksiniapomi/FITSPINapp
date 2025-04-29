//
//  NotificationsViewModel.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 27/04/2025.
//

import Foundation

enum NotificationType: String {
    case waterIntake = "Water Intake"
    case workoutCompleted = "Workout Completed"
    case termsUpdate = "Terms & Conditions"

    var iconName: String {
        switch self {
        case .waterIntake: return "drop.fill"
        case .workoutCompleted: return "figure.strengthtraining.traditional"
        case .termsUpdate: return "doc.text"
        }
    }

    var title: String {
        switch self {
        case .waterIntake: return "Water Reminder"
        case .workoutCompleted: return "Workout Completed"
        case .termsUpdate: return "Terms Updated"
        }
    }
}

struct NotificationItem: Identifiable, Equatable {
    let id = UUID()
    let type: NotificationType
    let message: String
    let date: Date
}

@MainActor
class NotificationsViewModel: ObservableObject {
    static let shared = NotificationsViewModel()

    @Published private(set) var items: [NotificationItem] = []

    func add(type: NotificationType, message: String, date: Date = Date()) {
        let notification = NotificationItem(type: type, message: message, date: date)
        items.insert(notification, at: 0)
    }

    func delete(_ item: NotificationItem) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
    }
}
