//
//  ShuffleViewModel.swift
//  FITSPIN app
//
//  Updated by Derya on 28/04/2025.
//

import Foundation
import CoreLocation

final class ShuffleViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var weather: Weather?
    @Published var errorMessage: String?
    @Published var workouts: [Workout] = []

    private let weatherService = WeatherService()
    private let geocoder = CLGeocoder()
    private let locationManager = CLLocationManager()

    func fetchWeatherAndWorkouts() async {
        await MainActor.run { self.isLoading = true }

        do {
            // Ensure location permissions
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

            let workoutList = try await WorkoutService.fetchWorkouts(for: weatherModel.temperature)

            await MainActor.run {
                self.weather = weatherModel
                self.workouts = workoutList
                self.isLoading = false
                self.errorMessage = nil
            }

        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to load: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }

    func recommendation(for temp: Double) -> String {
        temp >= 20 ? "It's a great day for a park workout!" : "Better to train indoors today 🏋️‍♂️"
    }
}
