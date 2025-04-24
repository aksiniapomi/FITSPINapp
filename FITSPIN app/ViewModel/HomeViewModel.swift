//
//  HomeViewModel.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 24/04/2025.
//

// ViewModel/HomeViewModel.swift

import Foundation
import CoreLocation

@MainActor
class HomeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
  @Published var weather: Weather?
  @Published var isLoading = false
  @Published var errorMessage: String?

  private let service = WeatherService()
  private let locationManager = CLLocationManager()
    
    override init() {
      super.init()
      locationManager.delegate = self
      // ask once for permission up‐front
      locationManager.requestWhenInUseAuthorization()
    }
    
    // delegate callback fires on the main thread
    nonisolated func locationManager(_ manager: CLLocationManager,
                           didChangeAuthorization status: CLAuthorizationStatus) {
        // once the user has granted permission, refetch
        if status == .authorizedWhenInUse || status == .authorizedAlways {
          Task { await fetchWeather() }
        }
      }

    func fetchWeather() async {
      // only proceed if we already have permission
        let status = locationManager.authorizationStatus
          guard status == .authorizedWhenInUse || status == .authorizedAlways else {
        errorMessage = "Location permission required to fetch weather."
        return
      }
      // then try to read a location
      guard let loc = locationManager.location else {
        errorMessage = "Unable to read your location."
        return
      }

      isLoading = true
      defer { isLoading = false }

      do {
        let resp = try await service.currentWeather(
          lat: loc.coordinate.latitude,
          lon: loc.coordinate.longitude
        )

      // Convert OpenWeatherMap ID → our Condition enum
      let condID = resp.weather.first?.id ?? 800
      let condition: Weather.Condition
      switch condID {
      case 800:                     condition = .clear
      case 801...802:              condition = .partlyCloudy
      case 200..<600:              condition = .rain
      case 600..<700:              condition = .snow
      case 200..<300, 900..<1000:  condition = .thunderstorm
      default:                      condition = .clear
      }
 //build the weather model 
          weather = Weather(
             temperature: resp.main.temp,
             condition: condition)
             
    } catch {
      errorMessage = error.localizedDescription
    }

    isLoading = false
  }
}
    // Hydration advice: baseline 2L/day + extra per hot degree
    /* let extra = max(0, tempC - 20) * 0.1   // +100ml per °C above 20
    let totalLitres = 2.0 + extra
    hydrationAdvice = String(format: "Aim for %.1f L of water today", totalLitres)
  }
} */

