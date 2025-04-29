//  ExerciseListViewModel.swift
//  FITSPIN app
//  Created by Derya Baglan on 24/04/2025.
//

import Foundation

@MainActor
class ExerciseListViewModel: ObservableObject {
    @Published private(set) var workouts: [Workout] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init() {
        Task { await loadWorkouts() }
    }
    
    func loadWorkouts() async {
        guard workouts.isEmpty else { return } //Prevent unnecessary reloads
        isLoading = true
        defer { isLoading = false }
        
        do {
            workouts = try await WgerAPI.shared.fetchWorkouts()
            errorMessage = nil
        } catch {
            errorMessage = "Failed to load workouts: \(error.localizedDescription)"
        }
    }
}


