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

    private init() {} // Private initializer to enforce singleton

    func add(type: NotificationType, message: String, date: Date = Date()) {
        let notification = NotificationItem(type: type, message: message, date: date)
        items.insert(notification, at: 0) // Insert newest at the top
    }

    func delete(_ item: NotificationItem) {
        items.removeAll { $0.id == item.id }
    }

    func clearAll() {
        items.removeAll()
    }
}
