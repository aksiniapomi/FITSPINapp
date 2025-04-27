//
//  WgerAPI.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 24/04/2025.
//

import Foundation

class WgerAPI {
    static let shared = WgerAPI()
    private let rootURL = URL(string: "https://wger.de/api/v2/")!
    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }()
    
    private init() {}

    // MARK: – Generic Fetch
    private func fetch<T: Codable>(_ path: String) async throws -> [T] {
        var allResults: [T] = []

        // Start with the first page
        var nextURL: URL? = rootURL.appendingPathComponent(path)

        while let url = nextURL {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            if components.queryItems == nil {
                components.queryItems = []
            }
            if !components.queryItems!.contains(where: { $0.name == "page_size" }) {
                components.queryItems!.append(URLQueryItem(name: "page_size", value: "100"))
            }

            guard let finalURL = components.url else {
                break
            }

            let (data, _) = try await URLSession.shared.data(from: finalURL)
            let page = try decoder.decode(PaginatedResponse<T>.self, from: data)

            allResults += page.results
            nextURL = page.next // Simplified and correct
        }

        return allResults
    }



    // MARK: – Individual Fetches
    func fetchEquipment() async throws -> [Equipment] {
        try await fetch("equipment/")
    }

    func fetchVideos() async throws -> [Video] {
        try await fetch("video/")
    }

    func fetchCategories() async throws -> [ExerciseCategory] {
        try await fetch("exercisecategory/")
    }

    func fetchTranslations() async throws -> [ExerciseTranslation] {
        try await fetch("exercise-translation/")
    }

    func fetchComments() async throws -> [ExerciseComment] {
        try await fetch("exercisecomment/")
    }

    func fetchExercises() async throws -> [Exercise] {
        try await fetch("exercise/")
    }

    // MARK: – Unified Workout Builder
    func fetchWorkouts() async throws -> [Workout] {
        async let allTranslations = fetchTranslations()
        async let videos = fetchVideos()
        async let equipmentList = fetchEquipment()
        async let categories = fetchCategories()
        async let comments = fetchComments()
        async let exercises = fetchExercises()

        let (trsAll, vids, equip, cats, cmts, exs) = try await (
            allTranslations, videos, equipmentList, categories, comments, exercises
        )

        let translations = trsAll.filter { $0.language == 2 } // English only

        let videosByExercise = Dictionary(grouping: vids, by: \.exercise)
        let commentsByTranslation = Dictionary(grouping: cmts, by: \.translation)
        let equipmentMap: [Int: String] = Dictionary(uniqueKeysWithValues: equip.map { ($0.id, $0.name) })
        let categoryMap: [Int: String] = Dictionary(uniqueKeysWithValues: cats.map { ($0.id, $0.name) })
        let exerciseMap = exs.reduce(into: [Int: Exercise]()) { dict, exercise in
            if dict[exercise.id] == nil {
                dict[exercise.id] = exercise
            }
        }


        return translations.compactMap { t in
            guard let exercise = exerciseMap[t.exercise],
                  let category = categoryMap[exercise.category],
                  let video = videosByExercise[t.exercise]?.first?.video else {
                return nil
            }

            let equipmentNames = exercise.equipment.compactMap { equipmentMap[$0] }

            return Workout(
                exerciseId: t.exercise,
                name: t.name,
                description: t.description,
                videoURL: video, // now guaranteed
                equipment: equipmentNames,
                category: category,
                comments: commentsByTranslation[t.id]?.map(\.comment) ?? []
            )

        }
    }
}

