//
//  CompletedWorkoutsStore.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 26/04/2025.
//

import Foundation
import SwiftUI

final class CompletedWorkoutsStore: ObservableObject {
    @Published private(set) var completed: [CompletedWorkout] = []
    
    private let service = WorkoutDatabaseService()
    
    init() {
        Task { [weak self] in
            await self?.load()
        }
    }
    
    func add(_ workout: Workout) {
        Task { [weak self] in
            try? await self?.service.addCompleted(workout: workout)
            await self?.load()
            
            //After saving, send a notification
            DispatchQueue.main.async {
                NotificationsViewModel.shared.add(
                    type: .workoutCompleted,
                    message: "🎉 You completed \(workout.name)! Keep it up!",
                    date: Date()
                )
            }
        }
    }
    
    func remove(_ workout: Workout) {
        Task { [weak self] in
            try? await self?.service.removeCompleted(workout: workout)
            await self?.load()
        }
    }
    
    func isCompletedToday(_ workout: Workout) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return completed.contains { $0.exerciseId == workout.exerciseId && Calendar.current.isDate($0.completedAt, inSameDayAs: today) }
    }
    
    private func load() async {
        do {
            let loaded = try await service.fetchCompleted()
            DispatchQueue.main.async { [weak self] in
                self?.completed = loaded
            }
        } catch {
            print("Failed to load completed workouts: \(error)")
        }
    }
}
