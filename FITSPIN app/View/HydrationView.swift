//
//  HydrationView.swift
//  FITSPIN app
//
//  Created by Xenia Pominova on 23/04/2025.
//

import SwiftUI

struct HydrationView: View {
    @State private var currentDate = Date()
    @State private var currentIntake: Double = 1.1
    private let dailyGoal: Double = 2.2

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
    private var fillFraction: CGFloat {
        min(1, max(0, currentIntake / dailyGoal))
    }
    private var suggestion: String {
        "Stay hydrated to power your workout"
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
                    Text("Today you will have to drink:")
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
                                        // load intake for that day...
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }

                    // Right arrow
                    Button {
                        // next month
                        currentDate = Calendar.current.date(
                            byAdding: .month,
                            value: +1,
                            to: currentDate
                        ) ?? currentDate
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.title3)
                            .foregroundColor(.fitspinOffWhite)
                    }
                }
                .padding(.horizontal, 16)

                //Logged intake
                Text(String(format: "Intake Logged: %.1f / %.1f L", currentIntake, dailyGoal))
                    .font(.subheadline)
                    .foregroundColor(.fitspinOffWhite)

                //Add water button
                Button {
                    currentIntake = min(dailyGoal, currentIntake + 0.1)
                    // save for currentDate...
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
            .preferredColorScheme(.dark)
    }
}
