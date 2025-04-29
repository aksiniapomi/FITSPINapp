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
    private var userId: String? {
        Auth.auth().currentUser?.uid
    }

    // Corrected load() without arguments
    func load() async {
        do {
            if let profile = try await service.loadProfile() {
                updateProfile(profile)
            }
        } catch {
            print("❌ Failed to load profile:", error.localizedDescription)
        }
    }

    // Still need userId for saving
    func save() async {
        guard let userId else {
            print("⚠️ No user ID found.")
            return
        }
        let profile = UserProfile(
            id: userId,
            age: age,
            height: height,
            weight: weight,
            fitnessLevel: fitnessLevel,
            goals: goals.map(\.rawValue)
        )

        do {
            try await service.saveProfile(profile)
        } catch {
            print("❌ Failed to save profile:", error.localizedDescription)
        }
    }

    private func updateProfile(_ profile: UserProfile) {
        self.age = profile.age
        self.height = profile.height
        self.weight = profile.weight
        self.fitnessLevel = profile.fitnessLevel
        self.goals = Set(profile.goals.compactMap(FitnessGoalsView.Goal.init(rawValue:)))
    }
}

