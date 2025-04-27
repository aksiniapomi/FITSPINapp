//  ExerciseListViewModel.swift
//  FITSPIN app
//  Created by Derya Baglan on 24/04/2025.
//



import Foundation

@MainActor
class ExerciseListViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    init() {
        Task { await loadWorkouts() }
    }

    func loadWorkouts() async {
        isLoading = true
        defer { isLoading = false }

        do {
            // One unified call — no need to stitch manually
            self.workouts = try await WgerAPI.shared.fetchWorkouts()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
