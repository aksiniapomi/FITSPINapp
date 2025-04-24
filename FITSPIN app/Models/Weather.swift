//
//  Weather.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 24/04/2025.
//

import Foundation

struct Weather {
    let temperature: Double    //in °C
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
                case .clear:         return "Perfect weather for a park workout!"
                case .partlyCloudy:  return "A few clouds-still great outside"
                case .rain:          return "Might want an indoor session today"
                case .snow:          return "Wrap up warm or hit the treadmill!"
                case .thunderstorm:  return "Better stay inside-storm’s coming."
            }
        }
    }
}
