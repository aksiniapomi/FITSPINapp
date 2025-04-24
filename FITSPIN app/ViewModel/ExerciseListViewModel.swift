
//  ExerciseListViewModel.swift
//  FITSPIN app
//  Created by Derya Baglan on 24/04/2025.
//

import Foundation

@MainActor
class ExerciseListViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    init() {
        Task { await loadWorkouts() }
    }

    func loadWorkouts() async {
        isLoading = true
        defer { isLoading = false }

        do {
            // 1. Fetch raw data concurrently
            async let translations = WgerAPI.shared.fetchTranslations()
            async let infos        = WgerAPI.shared.fetchExerciseInfo()
            async let vids         = WgerAPI.shared.fetchVideos()

            let (trs, infs, vs) = try await (translations, infos, vids)

            // 2. Index by exercise ID
            let infoById   = Dictionary(grouping: infs, by: { $0.exercise })
            let videosById = Dictionary(grouping: vs,  by: { $0.exercise })

            // 3. Map into your domain model
            self.workouts = trs.compactMap { t in
                guard let info = infoById[t.exercise]?.first else {
                    return nil
                }
                let firstVideoURL = videosById[t.exercise]?.first?.url

                return Workout(
                    apiId:      t.exercise,
                    title:      t.name,
                    type:       "Unknown",  // TODO: map via fetchCategories()
                    imageName:  t.name
                                  .lowercased()
                                  .replacingOccurrences(of: " ", with: ""),
                    videoURL:   firstVideoURL,
                    suggestions: info.description?
                                     .split(separator: ".")
                                     .map(String.init) ?? [],
                    sets:       3,
                    reps:       12,
                    equipment:  info.muscles.map(String.init), // TODO: map muscle → name
                    description: t.description,
                    muscleIds:  info.muscles
                )
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
