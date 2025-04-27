//
//  ProfileViewModel.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 27/04/2025.
//

import SwiftUI
import FirebaseAuth

@MainActor
class ProfileViewModel: ObservableObject {
  @Published var age: Int = 25
  @Published var height: Int = 170
  @Published var weight: Int = 70
  @Published var fitnessLevel: String = "Beginner"
  @Published var goals: Set<FitnessGoalsView.Goal> = []

  private let service = ProfileService()

  //Call from AccountView.onAppear
  func load() async {
    do {
      if let profile = try await service.loadProfile() {
        age = profile.age
        height = profile.height
        weight = profile.weight
        fitnessLevel = profile.fitnessLevel
        goals = Set(profile.goals.compactMap(FitnessGoalsView.Goal.init(rawValue:)))
      }
    } catch {
      print("failed to load profile:", error)
    }
  }

  //Call after the user taps Confirm
  func save() async {
    let profile = UserProfile(
      id: Auth.auth().currentUser?.uid,
      age: age,
      height: height,
      weight: weight,
      fitnessLevel: fitnessLevel,
      goals: goals.map(\.rawValue)
    )
    do {
      try await service.saveProfile(profile)
    } catch {
      print("failed to save profile:", error)
    }
  }
}
