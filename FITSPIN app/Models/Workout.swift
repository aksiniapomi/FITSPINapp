//
//  Workout.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 24/04/2025.
//

import Foundation

/// Your in-app Workout model, used for lists & detail screens
struct Workout: Identifiable, Hashable {
    /// Local UUID for SwiftUI
    let id = UUID()
    
    /// The wger API’s exercise ID
    let apiId: Int
    
    let title: String
    let type: String
    let imageName: String
    let videoURL: URL?
    let suggestions: [String]
    let sets: Int
    let reps: Int
    let equipment: [String]
    let description: String
    
    /// Raw muscle-group IDs from wger
    let muscleIds: [Int]
}
