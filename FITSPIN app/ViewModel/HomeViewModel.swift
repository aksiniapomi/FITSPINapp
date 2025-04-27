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
    @Published var city: String? //city field
    
    //dependencies
    private let service = WeatherService()
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()  //reverse geocoder
    
    override init() {
        super.init()
        locationManager.delegate = self
        // ask once for permission up‐front
        locationManager.requestWhenInUseAuthorization()
    }
    
    // delegate callback fires on the main thread
    //CCLocationManagerDelegate
    nonisolated func locationManager(_ manager: CLLocationManager,
                                     didChangeAuthorization status: CLAuthorizationStatus) {
        // once the user has granted permission, refetch
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            Task { await fetchWeather() }
        }
    }
    
    //fetch everything at once
    func fetchWeather() async {
        // only proceed if we already have permission
        let status = locationManager.authorizationStatus
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            errorMessage = "Location permission required to fetch weather."
            return
        }
        // then try to read a location - grab CLLocation
        guard let loc = locationManager.location else {
            errorMessage = "Unable to read your location."
            return
        }
        
        //city lookup
        await fetchCity(from: loc)
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let resp = try await service.currentWeather(
                lat: loc.coordinate.latitude,
                lon: loc.coordinate.longitude
            )
            
            // Convert OpenWeatherMap ID map to Condition enum
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
            errorMessage = nil
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    //Reverse-geocode helper
    //CLGoecoder in ios 15+ has an async throws API 
    private func fetchCity(from location: CLLocation) async {
      do {
        let places = try await geocoder.reverseGeocodeLocation(location)
        city = places.first?.locality
      } catch {
        print("reverse-geocode failed:", error)
        city = nil
      }
    }
  }




