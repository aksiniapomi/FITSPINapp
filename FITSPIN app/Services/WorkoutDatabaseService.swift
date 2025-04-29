//  WorkoutDatabaseService.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 29/04/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum ServiceError: Error {
    case notAuthenticated
}

final class WorkoutDatabaseService {
    private let db = Firestore.firestore()
    
    //Throws if there is no signed-in user
    private func requireUID() throws -> String {
        guard let u = Auth.auth().currentUser?.uid else {
            throw ServiceError.notAuthenticated
        }
        return u
    }
    
    func addCompleted(workout: Workout) async throws {
        let uid = try requireUID()
        let dateString = DateFormatter.completedWorkoutKeyFormatter.string(from: Date())
        let docID = "\(workout.exerciseId)_\(dateString)"
        let ref = db.collection("users")
            .document(uid)
            .collection("completedWorkouts")
        
        try await ref.document(docID).setData([
            "exerciseId": workout.exerciseId,
            "name":        workout.name,
            "category":    workout.category,
            "completedAt": Timestamp(date: Date())
        ])
    }
    
    func removeCompleted(workout: Workout) async throws {
        let uid = try requireUID()
        let dateString = DateFormatter.completedWorkoutKeyFormatter.string(from: Date())
        let docID = "\(workout.exerciseId)_\(dateString)"
        let ref = db.collection("users")
            .document(uid)
            .collection("completedWorkouts")
        
        try await ref.document(docID).delete()
    }
    
    func fetchCompleted() async throws -> [CompletedWorkout] {
        let uid = try requireUID()
        let ref = db.collection("users")
            .document(uid)
            .collection("completedWorkouts")
        
        let snap = try await ref.getDocuments()
        return snap.documents.compactMap { doc in
            guard
                let exerciseId = doc["exerciseId"] as? Int,
                let ts         = doc["completedAt"] as? Timestamp
            else { return nil }
            
            return CompletedWorkout(
                id: UUID(),
                exerciseId: exerciseId,
                completedAt: ts.dateValue()
            )
        }
    }
    
    func addFavourite(workout: Workout) async throws {
        let uid = try requireUID()
        let id  = String(workout.exerciseId)
        let ref = db.collection("users")
            .document(uid)
            .collection("favourites")
        
        try await ref.document(id).setData([
            "exerciseId": workout.exerciseId,
            "name":        workout.name,
            "category":    workout.category,
            "likedAt":     Timestamp(date: Date())
        ])
    }
    
    func removeFavourite(workout: Workout) async throws {
        let uid = try requireUID()
        let id  = String(workout.exerciseId)
        let ref = db.collection("users")
            .document(uid)
            .collection("favourites")
        
        try await ref.document(id).delete()
    }
    
    func fetchFavourites() async throws -> [Int: Date] {
        let uid = try requireUID()
        let ref = db.collection("users")
            .document(uid)
            .collection("favourites")
        
        let snap = try await ref.getDocuments()
        var result: [Int: Date] = [:]
        for doc in snap.documents {
            if let exerciseId = doc["exerciseId"] as? Int,
               let ts         = doc["likedAt"]    as? Timestamp {
                result[exerciseId] = ts.dateValue()
            }
        }
        return result
    }
}

extension DateFormatter {
    static let completedWorkoutKeyFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd" // Only date, no time
        return f
    }()
}
