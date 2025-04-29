//
//  ExerciseDetailViewModel.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 24/04/2025.
//
import Foundation

@MainActor
class ExerciseDetailViewModel: ObservableObject {
    @Published private(set) var workout: Workout?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadWorkout(apiId: Int) async {
        guard workout == nil else { return } // Prevent re-fetching if already loaded
        isLoading = true
        defer { isLoading = false }

        do {
            async let translationsTask = WgerAPI.shared.fetchTranslations()
            async let videosTask       = WgerAPI.shared.fetchVideos()
            async let equipmentTask    = WgerAPI.shared.fetchEquipment()
            async let exercisesTask    = WgerAPI.shared.fetchExercises()
            async let categoriesTask   = WgerAPI.shared.fetchCategories()
            async let commentsTask     = WgerAPI.shared.fetchComments()

            let (translations, videos, equipmentList, exercises, categories, comments) =
                try await (translationsTask, videosTask, equipmentTask, exercisesTask, categoriesTask, commentsTask)

            guard let translation = translations.first(where: { $0.exercise == apiId }),
                  let exercise = exercises.first(where: { $0.id == apiId }) else {
                throw URLError(.badServerResponse)
            }

            let videoURL = videos.first(where: { $0.exercise == apiId })?.video
            let commentList = comments.filter { $0.translation == translation.id }.map { $0.comment }

            let equipmentMap = Dictionary(uniqueKeysWithValues: equipmentList.map { ($0.id, $0.name) })
            let equipmentNames = exercise.equipment.compactMap { equipmentMap[$0] }

            let categoryMap = Dictionary(uniqueKeysWithValues: categories.map { ($0.id, $0.name) })
            let categoryName = categoryMap[exercise.category] ?? "General"

            // Create the enriched workout model
            self.workout = Workout(
                exerciseId: translation.exercise,
                name: translation.name,
                description: translation.description,
                videoURL: videoURL,
                equipment: equipmentNames,
                category: categoryName,
                comments: commentList
            )
            errorMessage = nil

        } catch {
            errorMessage = "⚠️ \(error.localizedDescription)"
        }
    }
}

