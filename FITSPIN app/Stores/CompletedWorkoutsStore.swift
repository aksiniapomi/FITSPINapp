//
//  CompletedWorkoutsStore.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 26/04/2025.
//


import Foundation
import SwiftUI

struct CompletedWorkout: Identifiable, Codable {
    let id = UUID()
    let exerciseId: Int
    let completedAt: Date

    var dateOnly: Date {
        Calendar.current.startOfDay(for: completedAt)
    }
}

final class CompletedWorkoutsStore: ObservableObject {
    @AppStorage("completedWorkouts") private var storedData: Data = Data()
    @Published private(set) var completed: [CompletedWorkout] = []

    init() {
        load()
    }

    func add(_ workout: Workout) {
        let entry = CompletedWorkout(exerciseId: workout.exerciseId, completedAt: Date())
        completed.append(entry)
        persist()
    }

    func remove(_ workout: Workout) {
        completed.removeAll { $0.exerciseId == workout.exerciseId }
        persist()
    }

    func isCompleted(_ workout: Workout) -> Bool {
        completed.contains { $0.exerciseId == workout.exerciseId }
    }

    private func load() {
        if let decoded = try? JSONDecoder().decode([CompletedWorkout].self, from: storedData) {
            completed = decoded
        }
    }

    private func persist() {
        if let encoded = try? JSONEncoder().encode(completed) {
            storedData = encoded
        }
    }
}
