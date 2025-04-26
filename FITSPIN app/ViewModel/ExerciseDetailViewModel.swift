//
//  ExerciseDetailViewModel.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 24/04/2025.
//

import Foundation

@MainActor
class ExerciseDetailViewModel: ObservableObject {
    @Published var workout: Workout?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadWorkout(apiId: Int) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            async let translations = WgerAPI.shared.fetchTranslations()
            async let videos       = WgerAPI.shared.fetchVideos()
            async let equipment    = WgerAPI.shared.fetchEquipment()
            async let exercises    = WgerAPI.shared.fetchExercises() // ✅ This is key
            async let categories   = WgerAPI.shared.fetchCategories()
            async let comments     = WgerAPI.shared.fetchComments()
            
            let (trs, vids, eqs, exs, cats, cmts) = try await (translations, videos, equipment, exercises, categories, comments)
            
            guard let t = trs.first(where: { $0.exercise == apiId }) else {
                throw URLError(.badServerResponse)
            }
            
            let videoURL = vids.first(where: { $0.exercise == apiId })?.video
            let commentList = cmts.filter { $0.translation == t.id }.map { $0.comment }
            
            // ✅ Match equipment through the Exercise object
            let exercise = exs.first(where: { $0.id == apiId })
            let equipmentMap = Dictionary(uniqueKeysWithValues: eqs.map { ($0.id, $0.name) })
            let equipmentNames = exercise?.equipment.compactMap { equipmentMap[$0] } ?? []
            
            // Match category
            let categoryMap = Dictionary(uniqueKeysWithValues: cats.map { ($0.id, $0.name) })
            let category = categoryMap[exercise?.category ?? 0] ?? "General"
            
            // ✅ Create enriched Workout
            let workout = Workout(
                exerciseId: t.exercise,
                name: t.name,
                description: t.description,
                videoURL: videoURL,
                equipment: equipmentNames,
                category: category,
                comments: commentList
            )
            
            self.workout = workout
        } catch {
            errorMessage = "⚠️ \(error.localizedDescription)"
        }
    }
}
