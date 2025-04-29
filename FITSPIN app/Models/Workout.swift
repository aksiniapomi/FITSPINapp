//
//  Workout.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 24/04/2025.
//
import Foundation

struct Workout: Identifiable, Hashable {
    let id = UUID()    // Local unique ID for SwiftUI use
    let exerciseId: Int   // Wger exercise ID
    
    let name: String   // ExerciseTranslation.name
    let description: String  // ExerciseTranslation.description
    
    let videoURL: URL?    // Video.video (optional)
    let equipment: [String]   // Equipment.name values
    let category: String      // ExerciseCategory.name
    let comments: [String]    // ExerciseComment.comment values
}
