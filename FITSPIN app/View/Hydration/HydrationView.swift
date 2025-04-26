//
//  HydrationView.swift
//  FITSPIN app
//
//  Created by Xenia Pominova on 23/04/2025.
//

import SwiftUI

struct HydrationView: View {
    
    @State private var currentDate = Date()
    
    //Inject HomeViewModel and HydrationVM so to read weather and hydration intake
    @EnvironmentObject private var homeVM: HomeViewModel
    @EnvironmentObject private var hydVM: HydrationViewModel
    
    //computed var dailyGoal taking weather into account
    private var dailyGoal: Double {
        let base: Double = 2.2 //base hydration requirement
        guard let temp = homeVM.weather?.temperature else {
            return base
        }
        switch temp {
        case 30...:     return base + 0.5  // very hot weather
        case 25..<30:   return base + 0.3  // moderately hot weather
        default:        return base
        }
    }
    
    //Replaced the fixed string with one driven by weather.condition
    private var suggestion: String {
        guard let cond = homeVM.weather?.condition else {
            return "Stay hydrated to power your workout"
        }
        switch cond {
        case .clear:
            return "Sunny day-drink water!"
        case .partlyCloudy:
            return "A bit cloudy-keep sipping on water"
        case .rain:
            return "Rainy weather—hydrate indoors"
        case .snow:
            return "Cold out there-warm up and hydrate"
        case .thunderstorm:
            return "Stormy—stay safe and keep water nearby"
        }
    }
    
    private var daysInMonth: [Int] {
        let cal = Calendar.current
        guard let rng = cal.range(of: .day, in: .month, for: currentDate)
        else { return [] }
        return Array(rng)
    }
    private var monthName: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "LLLL yyyy"
        return fmt.string(from: currentDate)
    }
    
    //how much you have to drink before the drop starts filling
    /*   private let fillThreshold: Double = 0.5
     
     private var fillFraction: CGFloat {
     // raw fraction of your total goal
     let raw = hydVM.todayIntake / dailyGoal
     
     // don’t show any fill until you hit the threshold
     guard hydVM.todayIntake >= fillThreshold else {
     return 0
     }
     // once you’re past the threshold, show the true proportion
     return CGFloat(min(1, max(0, raw)))
     }
     
     */
    
    private var fillFraction: CGFloat {
        CGFloat(min(1, hydVM.todayIntake / dailyGoal))
    }
    
    var body: some View {
        ZStack {
            Color.fitspinBackground.ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer().frame(height: 3)
                
                //Full-width logo
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
                
                // Title & suggestion
                VStack(spacing: 8) {
                    Text("Today you will need to drink:")
                        .font(.headline)
                        .foregroundColor(.fitspinYellow)
                    //computed daily goal
                    Text(String(format: "%.1f L", dailyGoal))
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.fitspinTangerine)
                    //computed suggestion
                    Text(suggestion)
                        .font(.subheadline)
                        .foregroundColor(.fitspinOffWhite.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    //only show when dailyGoal > base (i.e. weather bumped it up)
                    if dailyGoal > 2.2 {
                        Text("Because of today’s weather conditions you need extra water!")
                            .font(.caption)
                        //.italic()
                            .foregroundColor(.fitspinYellow.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                }
                
                //Fillable drop
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
                
                //Month name
                Text(monthName)
                    .font(.subheadline).bold()
                    .foregroundColor(.fitspinOffWhite)
                
                //Calendar with arrows
                HStack(alignment: .center, spacing: 8) {
                    // Left arrow
                    Button {
                        // go to previous month
                        currentDate = Calendar.current.date(
                            byAdding: .month,
                            value: -1,
                            to: currentDate
                        ) ?? currentDate
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.fitspinOffWhite)
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(daysInMonth, id: \.self) { day in
                                DayCircle(
                                    day: day,
                                    isSelected: Calendar.current.component(.day, from: currentDate) == day
                                )
                                .onTapGesture {
                                    var comps = Calendar.current.dateComponents(
                                        [.year, .month, .day],
                                        from: currentDate
                                    )
                                    comps.day = day
                                    if let d = Calendar.current.date(from: comps) {
                                        currentDate = d
                                        // load intake for that day
                                        Task { await hydVM.loadIntake(on: d) }
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    
                    // Right arrow
                    Button {
                        currentDate = Calendar.current.date(
                            byAdding: .month, value: +1, to: currentDate
                        ) ?? currentDate
                        Task { await hydVM.loadHistory(for: currentDate) }
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(.fitspinOffWhite)
                }
                .padding(.horizontal, 16)
                
                //Logged intake with dynamic dailyGoal
                Text(String(format: "Intake Logged: %.1f / %.1f L", hydVM.todayIntake, dailyGoal))
                    .font(.subheadline)
                    .foregroundColor(.fitspinOffWhite)
                
                //Add water button
                Button {
                    let next = min(dailyGoal, hydVM.todayIntake + 0.1)
                    Task { await hydVM.log(next, on: currentDate) }
                } label: {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.fitspinTangerine)
                }
                .frame(width: 56, height: 56)
                .overlay(
                    Circle()
                        .stroke(Color.fitspinTangerine, lineWidth: 2)
                )
                
                Spacer()
            }
            .padding(.bottom, 80)  // room for tab bar
        }
        .onAppear {
            // initial load for today
            Task {
                await hydVM.loadHistory(for: currentDate)
                await hydVM.loadIntake(on: currentDate)
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
    
    struct HydrationView_Previews: PreviewProvider {
        static var previews: some View {
            HydrationView()
                .environmentObject(HomeViewModel())
                .environmentObject(HydrationViewModel())
                .preferredColorScheme(.dark)
            
        }
    }
}
