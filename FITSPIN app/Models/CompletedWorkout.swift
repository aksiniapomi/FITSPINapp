//
//  CompletedWorkout.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 29/04/2025.
//

import Foundation

struct CompletedWorkout: Identifiable, Codable {
    let id: UUID
    let exerciseId: Int
    let completedAt: Date
    
    var dateOnly: Date {
        Calendar.current.startOfDay(for: completedAt)
    }
    
    init(id: UUID = UUID(), exerciseId: Int, completedAt: Date) {
        self.id = id
        self.exerciseId = exerciseId
        self.completedAt = completedAt
    }
}
