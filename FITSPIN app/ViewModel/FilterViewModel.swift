//  FITSPIN app
// FilterViewModel.swift
//  Created by Derya Baglan on 24/04/2025.
import Foundation
import CoreLocation

@MainActor
class FilterViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var categories: [ExerciseCategory] = []
    @Published var filteredWorkouts: [Workout] = []
    @Published var selectedCategory: String?
    @Published var weather: Weather?
    @Published var errorMessage: String?

    private var allWorkouts: [Workout] = []
    private let weatherService = WeatherService()
    private let locationManager = CLLocationManager()

    init() {
        locationManager.requestWhenInUseAuthorization()
        Task {
            await loadInitialData()
        }
    }

    private func loadInitialData() async {
        async let workoutsTask = WgerAPI.shared.fetchWorkouts()
        async let categoriesTask = WgerAPI.shared.fetchCategories()
        async let weatherTask = fetchWeather()

        do {
            let (workouts, apiCategories, weatherModel) = try await (workoutsTask, categoriesTask, weatherTask)
            self.allWorkouts = workouts
            self.filteredWorkouts = workouts
            self.categories = apiCategories.sorted { $0.name < $1.name }
            self.weather = weatherModel
            self.errorMessage = nil
        } catch {
            self.errorMessage = "Failed to load data: \(error.localizedDescription)"
        }
    }

    private func fetchWeather() async throws -> Weather {
        let status = locationManager.authorizationStatus
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            throw NSError(domain: "Location permission denied", code: 1)
        }

        guard let loc = locationManager.location else {
            throw NSError(domain: "Unable to get location", code: 2)
        }

        let response = try await weatherService.currentWeather(
            lat: loc.coordinate.latitude,
            lon: loc.coordinate.longitude
        )

        let condID = response.weather.first?.id ?? 800
        let condition: Weather.Condition = switch condID {
        case 800: .clear
        case 801...802: .partlyCloudy
        case 200..<600: .rain
        case 600..<700: .snow
        case 200..<300, 900..<1000: .thunderstorm
        default: .clear
        }

        return Weather(
            temperature: response.main.temp,
            condition: condition
        )
    }

    func search() {
        guard !searchText.isEmpty else {
            filteredWorkouts = allWorkouts
            return
        }
        filteredWorkouts = allWorkouts.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.category.localizedCaseInsensitiveContains(searchText)
        }
    }

    func applyCategory(_ name: String) {
        if selectedCategory == name {
            selectedCategory = nil
            filteredWorkouts = allWorkouts
        } else {
            selectedCategory = name
            filteredWorkouts = allWorkouts.filter {
                $0.category.localizedCaseInsensitiveContains(name)
            }
        }
    }
}
