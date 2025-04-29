//
//  FavouritesStore.swift
//  FITSPIN app
//

import SwiftUI

final class FavouritesStore: ObservableObject {
    @Published private(set) var favouriteIDs: [Int] = []
    @Published private(set) var favouriteDates: [Int: Date] = [:]

    private let service = WorkoutDatabaseService()

    init() {
        Task {
            await load()
        }
    }

    func toggle(_ workout: Workout) {
        if isFavourite(workout) {
            Task {
                try? await service.removeFavourite(workout: workout)
                await load()
            }
        } else {
            Task {
                try? await service.addFavourite(workout: workout)
                await load()
            }
        }
    }

    func isFavourite(_ workout: Workout) -> Bool {
        favouriteIDs.contains(workout.exerciseId)
    }

    func dateLiked(for workout: Workout) -> Date? {
        favouriteDates[workout.exerciseId]
    }

    func favourites(from allWorkouts: [Workout]) -> [Workout] {
        allWorkouts.filter { favouriteIDs.contains($0.exerciseId) }
    }

    private func load() async {
        do {
            let loaded = try await service.fetchFavourites()
            DispatchQueue.main.async {
                self.favouriteDates = loaded
                self.favouriteIDs = Array(loaded.keys)
            }
        } catch {
            print("❌ Failed to load favourites: \(error)")
        }
    }
}
