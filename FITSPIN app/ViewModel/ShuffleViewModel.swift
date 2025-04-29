//
//  ShuffleViewModel.swift
//  FITSPIN app
//
//  Updated by Derya on 28/04/2025.
//
import Foundation
import CoreLocation

@MainActor
final class ShuffleViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var weather: Weather?
    @Published var errorMessage: String?
    @Published var workouts: [Workout] = []
    
    private let weatherService = WeatherService()
    private let locationManager = CLLocationManager()
    private var location: CLLocation? {
        locationManager.location
    }
    
    init() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func fetchWeatherAndWorkouts() async {
        guard await ensureLocationPermissions() else {
            self.errorMessage = "Location permission denied"
            return
        }
        
        guard let loc = location else {
            self.errorMessage = "Unable to retrieve location"
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        async let weatherTask = fetchWeather(lat: loc.coordinate.latitude, lon: loc.coordinate.longitude)
        async let workoutsTask = WorkoutService.fetchWorkouts(for: loc.coordinate.latitude)
        
        do {
            let (weatherModel, workoutList) = try await (weatherTask, workoutsTask)
            self.weather = weatherModel
            self.workouts = workoutList
        } catch {
            self.errorMessage = "Failed to load: \(error.localizedDescription)"
        }
    }
    
    private func fetchWeather(lat: Double, lon: Double) async throws -> Weather {
        let response = try await weatherService.currentWeather(lat: lat, lon: lon)
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
    
    private func ensureLocationPermissions() async -> Bool {
        let status = locationManager.authorizationStatus
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        return status == .authorizedWhenInUse || status == .authorizedAlways
    }
    
    func recommendation(for temp: Double) -> String {
        temp >= 20 ? "It's a great day for a park workout!" : "Better to train indoors today 🏋️‍♂️"
    }
}

