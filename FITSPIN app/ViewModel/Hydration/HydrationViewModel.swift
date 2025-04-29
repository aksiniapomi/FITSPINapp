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
    @Published var todayIntake: Double = 0
    @Published private(set) var monthlyIntake: [String: [DailyIntake]] = [:]
    
    private let service = HydrationService()
    private let formatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM"
        return fmt
    }()
    
    private func monthKey(for date: Date) -> String {
        formatter.string(from: date)
    }
    
    private func loadIntake(for date: Date) async {
        do {
            todayIntake = try await service.intake(on: date)
        } catch {
            print("Failed to load intake for \(date):", error.localizedDescription)
        }
    }
    
    func reloadIntake(for date: Date) async {
        await loadIntake(for: date)
    }
    
    func loadToday() async {
        await loadIntake(for: Date())
    }
    
    func intakeHistory(for month: Date) -> [DailyIntake] {
        monthlyIntake[monthKey(for: month)] ?? []
    }
    
    func log(_ newTotal: Double, on date: Date) async {
        todayIntake = newTotal
        do {
            try await service.set(intake: newTotal, for: date)
        } catch {
            print("Failed to save intake:", error.localizedDescription)
        }
    }
    
    func loadHistory(for month: Date) async {
        let key = monthKey(for: month)
        if monthlyIntake[key] != nil {
            return
        }
        do {
            let data = try await service.intakeHistory(monthOf: month)
            monthlyIntake[key] = data
        } catch {
            print("Failed to load history:", error.localizedDescription)
        }
    }
}

