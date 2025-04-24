//
//  ExerciseDetailViewModel.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 24/04/2025.
//

import Foundation    // for Task.sleep

/// ViewModel for loading or refreshing a single Workout
@MainActor
class ExerciseDetailViewModel: ObservableObject {
    @Published var workout: Workout?
    @Published var isLoading = false
    @Published var errorMessage: String?

    /// Load a workout by its API ID
    func loadWorkout(apiId: Int) async {
        isLoading = true
        defer { isLoading = false }

        do {
            // Simulate network delay
            try await Task.sleep(nanoseconds: 1_000_000_000)

            // TODO: replace this block with your real API fetching logic
            let fetched = Workout(
                apiId:      apiId,
                title:      "Sample Workout",
                type:       "Demo",
                imageName:  "exercise_thumbnail",
                videoURL:   nil,
                suggestions:["Tip 1", "Tip 2"],
                sets:       3,
                reps:       12,
                equipment:  ["None"],
                description:"This is a placeholder workout until your API is wired up.",
                muscleIds:  []
            )

            workout = fetched
            errorMessage = nil

        } catch {
            errorMessage = "Failed to load workout: \(error.localizedDescription)"
        }
    }
}
