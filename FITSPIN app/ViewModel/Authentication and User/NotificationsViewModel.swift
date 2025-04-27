//
//  NotificationsViewModel.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 27/04/2025.
//

import Foundation

//What kind of notification is this?
enum NotificationType: String {
  case waterIntake = "Water Intake"
  case workoutTip  = "Workout Tip"
  case termsUpdate = "Terms & Conditions"

  //A matching SF Symbol
  var iconName: String {
    switch self {
    case .waterIntake: return "drop.fill"
    case .workoutTip:  return "figure.strengthtraining.traditional"
    case .termsUpdate: return "doc.text"
    }
  }
}

struct NotificationItem: Identifiable {
  let id      = UUID()
  let type    : NotificationType
  let message : String
  let date    : Date
}

@MainActor
class NotificationsViewModel: ObservableObject {
  @Published private(set) var items: [NotificationItem] = []

  //Add a new notification (inserted at top)
  func add(type: NotificationType,
           message: String,
           date: Date = Date())
  {
    let note = NotificationItem(type: type,
                                message: message,
                                date: date)
    items.insert(note, at: 0)
  }
}
