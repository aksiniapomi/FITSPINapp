//
//  WorkoutDatabaseService.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 29/04/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class WorkoutDatabaseService {
    private let db = Firestore.firestore()
    
    private var uid: String {
        guard let u = Auth.auth().currentUser?.uid else {
            fatalError("WorkoutDatabaseService requires a signed-in user.")
        }
        return u
    }
    
    private var completedRef: CollectionReference {
        db.collection("users").document(uid).collection("completedWorkouts")
    }
    
    private var favouritesRef: CollectionReference {
        db.collection("users").document(uid).collection("favourites")
    }
    
    // MARK: - Completed Workouts

    func addCompleted(workout: Workout) async throws {
        let dateString = DateFormatter.completedWorkoutKeyFormatter.string(from: Date())
        let id = "\(workout.exerciseId)_\(dateString)"  // ← Unique per day
        try await completedRef.document(id).setData([
            "exerciseId": workout.exerciseId,
            "name": workout.name,
            "category": workout.category,
            "completedAt": Timestamp(date: Date())
        ])
    }



    func removeCompleted(workout: Workout) async throws {
        let id = String(workout.exerciseId)
        try await completedRef.document(id).delete()
    }

    func fetchCompleted() async throws -> [CompletedWorkout] {
        let snap = try await completedRef.getDocuments()
        return snap.documents.compactMap { doc in
            guard
                let exerciseId = doc["exerciseId"] as? Int,
                let ts = doc["completedAt"] as? Timestamp
            else {
                return nil
            }
            return CompletedWorkout(id: UUID(), exerciseId: exerciseId, completedAt: ts.dateValue())
        }
    }

    // MARK: - Favourites

    func addFavourite(workout: Workout) async throws {
        let id = String(workout.exerciseId)
        try await favouritesRef.document(id).setData([
            "exerciseId": workout.exerciseId,
            "name": workout.name,
            "category": workout.category,
            "likedAt": Timestamp(date: Date())
        ])
    }


    func removeFavourite(workout: Workout) async throws {
        let id = String(workout.exerciseId)
        try await favouritesRef.document(id).delete()
    }

    func fetchFavourites() async throws -> [Int: Date] {
        let snap = try await favouritesRef.getDocuments()
        var result: [Int: Date] = [:]
        for doc in snap.documents {
            if let exerciseId = doc["exerciseId"] as? Int,
               let ts = doc["likedAt"] as? Timestamp {
                result[exerciseId] = ts.dateValue()
            }
        }
        return result
    }
}

extension DateFormatter {
    static let completedWorkoutKeyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Only date, no time
        return formatter
    }()
}
