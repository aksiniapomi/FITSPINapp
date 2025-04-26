//
//  DailyIntake.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 26/04/2025.
//

import Foundation

//One day’s worth of water intake
struct DailyIntake: Identifiable, Codable {
  let id = UUID()
  let date: Date
  let liters: Double
}
