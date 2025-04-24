//
//  Workout.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 24/04/2025.
//
// Workout.swift
import Foundation

struct Workout: Identifiable {
  let id = UUID()
  let title: String
  let type: String
  let imageName: String
  // optional playback metadata
  let videoURL: URL?
  let suggestions: [String]
  let sets: Int
  let reps: Int
}


