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
    let language: Int // Keeping this in case it's ever needed for filtering/sorting
}



