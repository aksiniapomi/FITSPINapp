//
//  WeatherService.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 24/04/2025.
//

import Foundation

struct WeatherResponse: Decodable {
    struct Main: Decodable {
        let temp: Double   // must be present
    }
    struct Condition: Decodable {
        let id: Int        // must be present
    }
    
    let weather: [Condition]  // array with at least one element
    let main: Main
    
}

enum WeatherError: LocalizedError {
    case invalidURL
    case network(Error)
    case decoding(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL – did you set your API key in Info.plist?"
        case .network(let err):
            return "Network error: \(err.localizedDescription)"
        case .decoding(let err):
            return "Decoding error: \(err.localizedDescription)"
        }
    }
}

actor WeatherService {
    private let apiKey = Bundle.main
        .object(forInfoDictionaryKey: "OPEN_WEATHER_API_KEY") as? String
    
    init() {
       print("OPEN_WEATHER_API_KEY is", apiKey ?? "nil")
     }
    
    func currentWeather(lat: Double, lon: Double) async throws -> WeatherResponse {
        guard let key = apiKey,
              var comps = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")
        else {
            throw WeatherError.invalidURL
        }
        
        comps.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
            URLQueryItem(name: "appid", value: key),
            URLQueryItem(name: "units", value: "metric")        //metric for °C
        ]
        
        let url = comps.url!
        do {
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            return try JSONDecoder().decode(WeatherResponse.self, from: data)
        } catch let decodeError as DecodingError {
            // print the full error to the console:
            print("JSON decode failed:", decodeError)
            if let json = String(data: (try? await URLSession.shared.data(from: url).0) ?? Data(),
                                 encoding: .utf8){
                print("JSON payload was:", json)
            }
            throw WeatherError.decoding(decodeError)
        }
    }
}
