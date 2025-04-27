//
//  HydrationViewModel.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 26/04/2025.
//

import Foundation
import SwiftUI

@MainActor
class HydrationViewModel: ObservableObject {
  //Today’s total (used by HydrationView)
  @Published var todayIntake: Double = 0

  //All loaded months’ data, keyed by "yyyy-MM"
  @Published private(set) var monthlyIntake: [String: [DailyIntake]] = [:]

  private let service = HydrationService()

  private func monthKey(from date: Date) -> String {
    let fmt = DateFormatter()
    fmt.dateFormat = "yyyy-MM"
    return fmt.string(from: date)
  }
    
    //Load a single day’s intake
    func loadIntake(on date: Date) async {
      do {
        todayIntake = try await service.intake(on: date)
      } catch {
        print("failed to load intake for \(date):", error)
      }
    }

  //Returns the array for that month (or empty if not yet loaded)
  func intakeHistory(for month: Date) -> [DailyIntake] {
    monthlyIntake[monthKey(from: month)] ?? []
  }

  //Call once on launch / onAppear of HydrationView
  func loadToday() async {
    do {
      todayIntake = try await service.intake(on: Date())
    } catch {
      print("failed to load today’s intake:", error)
    }
  }

    // Log a total for an arbitrary date
    func log(_ newTotal: Double, on date: Date) async {
      todayIntake = newTotal
      do {
        try await service.set(intake: newTotal, for: date)
      } catch {
        print("failed to save intake:", error)
      }
    }

  //Load & cache a specific month’s history from Firebase
  func loadHistory(for month: Date) async {
    do {
      let data = try await service.intakeHistory(monthOf: month)
      monthlyIntake[monthKey(from: month)] = data
    } catch {
      print("failed to load history:", error)
    }
  }
}
