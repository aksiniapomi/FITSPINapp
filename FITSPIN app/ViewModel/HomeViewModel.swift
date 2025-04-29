//
//  HomeViewModel.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 24/04/2025.
//
import Foundation
import CoreLocation

@MainActor
class HomeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var weather: Weather?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var city: String?

    private let service = WeatherService()
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    // Location manager delegate
    nonisolated func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            Task { await fetchWeather() }
        }
    }

    func fetchWeather() async {
        guard await ensureLocationPermissions() else {
            errorMessage = "Location permission required to fetch weather."
            return
        }

        guard let loc = locationManager.location else {
            errorMessage = "Unable to retrieve location."
            return
        }

        isLoading = true
        defer { isLoading = false }

        async let weatherTask = fetchWeatherData(lat: loc.coordinate.latitude, lon: loc.coordinate.longitude)
        async let cityTask = fetchCity(from: loc)

        do {
            let (weatherResult, cityResult) = try await (weatherTask, cityTask)
            self.weather = weatherResult
            self.city = cityResult
            self.errorMessage = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    private func fetchWeatherData(lat: Double, lon: Double) async throws -> Weather {
        let response = try await service.currentWeather(lat: lat, lon: lon)
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

    private func fetchCity(from location: CLLocation) async throws -> String? {
        let places = try await geocoder.reverseGeocodeLocation(location)
        return places.first?.locality
    }

    private func ensureLocationPermissions() async -> Bool {
        let status = locationManager.authorizationStatus
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        return status == .authorizedWhenInUse || status == .authorizedAlways
    }
}

