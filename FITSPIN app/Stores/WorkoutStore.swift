//
//  WorkoutStore.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 26/04/2025.
//

import Foundation
import SwiftUI

final class WorkoutStore: ObservableObject {
    @Published var workouts: [Workout] = []

    init() {
        Task {
            await loadAll()
        }
    }

    func loadAll() async {
        do {
            let fetched = try await WgerAPI.shared.fetchWorkouts()
            DispatchQueue.main.async {
                self.workouts = fetched
            }
        } catch {
            print("❌ Failed to fetch workouts: \(error)")
        }
    }
}
