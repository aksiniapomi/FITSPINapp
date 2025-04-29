//
//  Weather.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 24/04/2025.
//

import Foundation

struct Weather {
    let temperature: Double //in °C
    let condition: Condition
    
    enum Condition: String {
        case clear
        case partlyCloudy = "partly_cloudy"
        case rain
        case snow
        case thunderstorm
        
        var iconName: String {
            switch self {
            case .clear:         return "sun.max.fill"
            case .partlyCloudy:  return "cloud.sun.fill"
            case .rain:          return "cloud.rain.fill"
            case .snow:          return "cloud.snow.fill"
            case .thunderstorm:  return "cloud.bolt.rain.fill"
            }
        }
        
        var description: String {
            switch self {
            case .clear:
                return "Clear skies and great vibes. \nLet’s get moving today!"
            case .partlyCloudy:
                return "A few clouds won’t stop us. \nPerfect time for a refreshing session!"
            case .rain:
                return "Rainy days call for cozy workouts. \nLet’s sweat it out!"
            case .snow:
                return "Snowflakes and strong reps. \nStay warm and train smart today!"
            case .thunderstorm:
                return "Storm’s rolling in — time to stay safe. \nLet’s power through an workout!"
            }
        }
    }
}
