//
//  ExerciseTranslation.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 25/04/2025.
//
import Foundation

struct ExerciseTranslation: Codable, Identifiable {
    let id: Int
    let exercise: Int
    let name: String
    let description: String
    let language: Int //in case it's needed for filtering/sorting
}
