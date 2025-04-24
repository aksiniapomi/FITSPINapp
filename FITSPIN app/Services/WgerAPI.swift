//
//  WgerAPI.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 24/04/2025.
//

import Foundation

// MARK: — Paginated Response

struct PaginatedResponse<T: Codable>: Codable {
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [T]
}

// MARK: — API Models

struct Equipment: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String?
}

struct Video: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let exercise: Int
    let licenseAuthor: String?
    let url: URL?
    let duration: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, description, exercise, url, duration
        case licenseAuthor = "license_author"
    }
}

struct ExerciseCategory: Codable, Identifiable {
    let id: Int
    let name: String
}

struct ExerciseTranslation: Codable, Identifiable {
    let id: Int
    let exercise: Int
    let language: String
    let name: String
    let description: String
}

struct ExerciseInfo: Codable, Identifiable {
    let id: Int
    let exercise: Int
    let language: String
    let description: String?
    let muscles: [Int]
}

// NOTE: ExerciseComment lives in Models/Comment.swift

// MARK: — Wger API Client

class WgerAPI {
    static let shared = WgerAPI()
    private let rootURL = URL(string: "https://wger.de/api/v2/")!
    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }()

    private init() {}

    /// Generic fetch helper for any Codable type
    private func fetch<T: Codable>(_ path: String) async throws -> [T] {
        var components = URLComponents(
            url: rootURL.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        )!
        components.queryItems = [URLQueryItem(name: "page_size", value: "100")]
        let url = components.url!

        let (data, _) = try await URLSession.shared.data(from: url)
        let page = try decoder.decode(PaginatedResponse<T>.self, from: data)
        return page.results
    }

    /// List of all equipment
    func fetchEquipment() async throws -> [Equipment] {
        try await fetch("equipment/")
    }

    /// List of all videos
    func fetchVideos() async throws -> [Video] {
        try await fetch("video/")
    }

    /// List of all exercise categories
    func fetchCategories() async throws -> [ExerciseCategory] {
        try await fetch("exercisecategory/")
    }

    /// List of all exercise translations
    func fetchTranslations() async throws -> [ExerciseTranslation] {
        try await fetch("exercise-translation/")
    }

    /// List of all exercise info entries
    func fetchExerciseInfo() async throws -> [ExerciseInfo] {
        try await fetch("exerciseinfo/")
    }

}

