//  FITSPIN app
//
//  Created by Derya Baglan on 24/04/2025.

import Foundation

@MainActor
class FilterViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var categories: [ExerciseCategory] = []
    @Published var filteredWorkouts: [Workout] = []
    @Published var selectedCategory: String? = nil


    private var allWorkouts: [Workout] = []

    init() {
        Task {
            await fetchInitialData()
        }
    }
    func fetchInitialData() async {
        do {
            let workouts = try await WgerAPI.shared.fetchWorkouts()
            self.allWorkouts = workouts
            self.filteredWorkouts = workouts

            // Create categories from actual data
            let uniqueCategories = Set(workouts.map(\.category))
            self.categories = uniqueCategories.enumerated().map { index, title in
                ExerciseCategory(id: index, name: title)
            }

        } catch {
            print("❌ Failed to load workouts:", error.localizedDescription)
        }
    }

    func search() {
        if searchText.isEmpty {
            filteredWorkouts = allWorkouts
        } else {
            filteredWorkouts = allWorkouts.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.category.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    func applyCategory(_ name: String) {
        if selectedCategory == name {
            //  Tapped the same filter: clear it
            selectedCategory = nil
            filteredWorkouts = allWorkouts
        } else {
            //  New filter
            selectedCategory = name
            filteredWorkouts = allWorkouts.filter {
                $0.category.localizedCaseInsensitiveContains(name)
            }
        }
    }

}

