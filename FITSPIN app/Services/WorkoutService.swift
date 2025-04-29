//
//  WorkoutService.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 28/04/2025.
//

import Foundation

struct WorkoutService {
    static func fetchWorkouts(for temperature: Double) async throws -> [Workout] {
        let all = try await WgerAPI.shared.fetchWorkouts()
        
        if temperature >= 20 {
            // Outdoor: no equipment OR only a gym mat
            return all.filter { workout in
                let equipment = workout.equipment.map { $0.lowercased() }
                return equipment.isEmpty || (equipment.count == 1 && equipment.first?.contains("mat") == true)
            }
        } else {
            // Indoor: all workouts
            return all
        }
    }
}
