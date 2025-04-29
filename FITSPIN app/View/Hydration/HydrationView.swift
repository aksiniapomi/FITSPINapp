//
//  HydrationView.swift
//  FITSPIN app
//
//  Created by Xenia Pominova on 23/04/2025.
//

import SwiftUI

struct HydrationView: View {
    
    @State private var currentDate = Date()
    
    @EnvironmentObject private var homeVM: HomeViewModel
    @EnvironmentObject private var hydVM: HydrationViewModel
    @EnvironmentObject private var notificationsVM: NotificationsViewModel
    
    // Computed property for daily hydration goal based on weather
    private var dailyGoal: Double {
        let base: Double = 2.2
        guard let temp = homeVM.weather?.temperature else { return base }
        switch temp {
        case 30...:     return base + 0.5
        case 25..<30:   return base + 0.3
        default:        return base
        }
    }
    
    // Hydration suggestion based on weather
    private var suggestion: String {
        guard let cond = homeVM.weather?.condition else {
            return "Stay hydrated to power your workout"
        }
        switch cond {
        case .clear:        return "Sunny day — drink water!"
        case .partlyCloudy: return "A bit cloudy — keep sipping on water"
        case .rain:         return "Rainy — hydrate indoors"
        case .snow:         return "Cold — warm up and hydrate"
        case .thunderstorm: return "Stormy — stay safe and hydrate"
        }
    }
    
    // Days in the current month
    private var daysInMonth: [Int] {
        let cal = Calendar.current
        guard let range = cal.range(of: .day, in: .month, for: currentDate) else { return [] }
        return Array(range)
    }
    
    private var monthName: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "LLLL yyyy"
        return fmt.string(from: currentDate)
    }
    
    private var fillFraction: CGFloat {
        CGFloat(min(1, hydVM.todayIntake / dailyGoal))
    }
    
    var body: some View {
        ZStack {
            Color.fitspinBackground.ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer().frame(height: 3)
                
                // Logo
                HStack {
                    Image("fitspintext")
                        .resizable()
                        .renderingMode(.original)
                        .scaledToFit()
                        .frame(width: 180)
                    Spacer()
                }
                .padding(.leading, 3)
                .padding(.top, 4)
                
                // Title & Suggestion
                VStack(spacing: 8) {
                    Text("Today you will need to drink:")
                        .font(.headline)
                        .foregroundColor(.fitspinYellow)
                    
                    Text(String(format: "%.1f L", dailyGoal))
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.fitspinTangerine)
                    
                    Text(suggestion)
                        .font(.subheadline)
                        .foregroundColor(.fitspinOffWhite.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    if dailyGoal > 2.2 {
                        Text("Because of today’s weather conditions you need extra water!")
                            .font(.caption)
                            .foregroundColor(.fitspinYellow.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                }
                
                // Fillable drop
                ZStack {
                    Image(systemName: "drop.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 160)
                        .foregroundColor(.fitspinBlue.opacity(0.4))
                    
                    GeometryReader { geo in
                        let h = geo.size.height
                        Rectangle()
                            .fill(Color.fitspinBlue)
                            .frame(height: h * fillFraction)
                            .offset(y: h * (1 - fillFraction))
                            .mask(
                                Image(systemName: "drop.fill")
                                    .resizable()
                                    .scaledToFit()
                            )
                    }
                    .frame(width: 160, height: 160)
                }
                .frame(height: 160)
                
                // Month name
                Text(monthName)
                    .font(.subheadline).bold()
                    .foregroundColor(.fitspinOffWhite)
                
                // Calendar arrows + day circles
                HStack(alignment: .center, spacing: 8) {
                    // Left arrow
                    Button {
                        currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
                        Task { await hydVM.loadHistory(for: currentDate) }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.fitspinOffWhite)
                    }
                    
                    // Day circles
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(daysInMonth, id: \.self) { day in
                                DayCircle(
                                    day: day,
                                    isSelected: Calendar.current.component(.day, from: currentDate) == day
                                )
                                .onTapGesture {
                                    var comps = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
                                    comps.day = day
                                    if let newDate = Calendar.current.date(from: comps) {
                                        currentDate = newDate
                                        Task { await hydVM.reloadIntake(for: currentDate) }
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    
                    // Right arrow
                    Button {
                        currentDate = Calendar.current.date(byAdding: .month, value: +1, to: currentDate) ?? currentDate
                        Task { await hydVM.loadHistory(for: currentDate) }
                    } label: {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.fitspinOffWhite)
                    }
                }
                .padding(.horizontal, 16)
                
                // Logged intake
                Text(String(format: "Intake Logged: %.1f / %.1f L", hydVM.todayIntake, dailyGoal))
                    .font(.subheadline)
                    .foregroundColor(.fitspinOffWhite)
                
                // Add water button
                Button {
                    let next = min(dailyGoal, hydVM.todayIntake + 0.1)
                    Task { await hydVM.log(next, on: currentDate) }
                    if next >= dailyGoal {
                        notificationsVM.add(
                            type: .waterIntake,
                            message: "🎉 Great job! You've reached your \(String(format: "%.1f", dailyGoal)) L goal today.",
                            date: Date()
                        )
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.fitspinTangerine)
                }
                .frame(width: 56, height: 56)
                .overlay(Circle().stroke(Color.fitspinTangerine, lineWidth: 2))
                
                Spacer()
            }
            .padding(.bottom, 80)
        }
        .onAppear {
            Task {
                await hydVM.loadHistory(for: currentDate)
                await hydVM.reloadIntake(for: currentDate)
            }
        }
    }
    
    fileprivate struct DayCircle: View {
        let day: Int
        let isSelected: Bool
        
        var body: some View {
            Text("\(day)")
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(isSelected ? .fitspinOffWhite : .fitspinBackground)
                .frame(width: 36, height: 36)
                .background(
                    Circle().fill(isSelected ? Color.fitspinBlue : .fitspinOffWhite)
                )
        }
    }
}

struct HydrationView_Previews: PreviewProvider {
    static var previews: some View {
        HydrationView()
            .environmentObject(HomeViewModel())
            .environmentObject(HydrationViewModel())
            .environmentObject(NotificationsViewModel.shared)
            .preferredColorScheme(.dark)
    }
}
