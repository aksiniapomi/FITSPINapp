//
//  FITSPIN app
//
//  Created by Derya Baglan on 25/04/2025.
//
// Comment.swift

import Foundation

struct ExerciseComment: Codable, Identifiable {
    let id: Int
    let uuid: String
    let comment: String
    let translation: Int
}

