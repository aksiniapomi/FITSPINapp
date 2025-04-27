//
//  FavouritesStore.swift
//  FITSPIN app
//

import SwiftUI

final class FavouritesStore: ObservableObject {
    @AppStorage("favouriteWorkoutIDs") private var storedIDsData: Data = Data()
    @AppStorage("favouriteWorkoutDates") private var storedDatesData: Data = Data()

    @Published private(set) var favouriteIDs: [Int] = []
    @Published private(set) var favouriteDates: [Int: Date] = [:]

    init() {
        load()
    }

    // MARK: - Public API

    func toggle(_ workout: Workout) {
        if isFavourite(workout) {
            remove(workout: workout)
        } else {
            save(workout: workout)
        }
    }

    func save(workout: Workout) {
        if !favouriteIDs.contains(workout.exerciseId) {
            favouriteIDs.append(workout.exerciseId)
            favouriteDates[workout.exerciseId] = Date()
            persist()
        }
    }

    func remove(workout: Workout) {
        favouriteIDs.removeAll { $0 == workout.exerciseId }
        favouriteDates.removeValue(forKey: workout.exerciseId)
        persist()
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

    // MARK: - Persistence

    private func load() {
        if let decodedIDs = try? JSONDecoder().decode([Int].self, from: storedIDsData) {
            favouriteIDs = decodedIDs
        }

        if let decodedDates = try? JSONDecoder().decode([Int: Date].self, from: storedDatesData) {
            favouriteDates = decodedDates
        }
    }

    private func persist() {
        if let encodedIDs = try? JSONEncoder().encode(favouriteIDs) {
            storedIDsData = encodedIDs
        }

        if let encodedDates = try? JSONEncoder().encode(favouriteDates) {
            storedDatesData = encodedDates
        }
    }
}
