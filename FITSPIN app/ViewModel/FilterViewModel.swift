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
    @Published var selectedCategory: String? = nil
    @Published var weather: Weather?
    @Published var errorMessage: String?

    private var allWorkouts: [Workout] = []
    private let weatherService = WeatherService()
    private let locationManager = CLLocationManager()

    init() {
        Task {
            await fetchInitialData()
            await fetchWeather()
        }
    }

    func fetchInitialData() async {
        async let workoutsTask = WgerAPI.shared.fetchWorkouts()
        async let categoriesTask = WgerAPI.shared.fetchCategories()

        do {
            let (workouts, apiCategories) = try await (workoutsTask, categoriesTask)
            self.allWorkouts = workouts
            self.filteredWorkouts = workouts

            self.categories = apiCategories.sorted(by: { $0.name < $1.name })
        } catch {
            print("❌ Failed to load workouts or categories:", error.localizedDescription)
        }
    }

    func fetchWeather() async {
        do {
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
            let condition: Weather.Condition
            switch condID {
            case 800: condition = .clear
            case 801...802: condition = .partlyCloudy
            case 200..<600: condition = .rain
            case 600..<700: condition = .snow
            case 200..<300, 900..<1000: condition = .thunderstorm
            default: condition = .clear
            }

            let weatherModel = Weather(
                temperature: response.main.temp,
                condition: condition
            )

            self.weather = weatherModel
        } catch {
            self.errorMessage = "Failed to fetch weather: \(error.localizedDescription)"
        }
    }

    func search() {
        if searchText.isEmpty {
            filteredWorkouts = allWorkouts
        } else {
            filteredWorkouts = allWorkouts.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.category.localizedCaseInsensitiveContains(searchText)
            }
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

