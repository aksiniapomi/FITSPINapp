//
//  IntakeChartView.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 23/04/2025.
//

import SwiftUI
import Charts

// daily‐intake model
struct DailyIntake: Identifiable {
    let id = UUID()
    let date: Date
    let liters: Double
}

// A sample month’s worth of data
fileprivate let sampleIntake: [DailyIntake] = {
    let calendar = Calendar.current
    let today = Date()
    let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
    return (0..<calendar.range(of: .day, in: .month, for: today)!.count).map { offset in
        let d = calendar.date(byAdding: .day, value: offset, to: startOfMonth)!
        // random demo data between 1.0 and 2.5L
        return DailyIntake(date: d, liters: Double.random(in: 1...2.5))
    }
}()

struct IntakeChartView: View {
    @State private var data: [DailyIntake] = sampleIntake
    @State private var selectedMonth: Date = Date()
    
    private var monthName: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "LLLL yyyy"
        return fmt.string(from: selectedMonth)
    }
    
    var body: some View {
        
        ZStack {
            Color.fitspinBackground.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                
                Spacer()
                // Header
                Text("Water Intake History")
                    .font(.title2).bold()
                    .foregroundColor(.fitspinBlue)
                
                // Month selector
                HStack {
                    Button {
                        changeMonth(by: -1)
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .buttonStyle(.borderless)
                    .foregroundColor(.fitspinYellow)
                    
                    Spacer()
                    
                    Text(monthName)
                        .font(.headline)
                        .foregroundColor(.fitspinYellow)
                    
                    Spacer()
                    Button {
                        changeMonth(by: +1)
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                    .buttonStyle(.borderless)
                    .foregroundColor(.fitspinYellow)
                }
                
                // The Chart
                Chart(data) { entry in
                    BarMark(
                        x: .value("Day", entry.date, unit: .day),
                        y: .value("Liters", entry.liters)
                    )
                    .foregroundStyle(Color.fitspinBlue.gradient)
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: 5)) { _ in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: .dateTime.day())
                            .foregroundStyle(Color.fitspinOffWhite)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { _ in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel()
                            .foregroundStyle(Color.fitspinOffWhite)
                    }
                }
                .frame(height: 240)
                
                Spacer()
            }
            .padding()
            .background(Color.fitspinBackground.ignoresSafeArea())
        }
    }
    
    private func changeMonth(by months: Int) {
        let cal = Calendar.current
        if let newDate = cal.date(byAdding: .month, value: months, to: selectedMonth) {
            selectedMonth = newDate
            // reload `data` from your storage for that month
        }
    }
}

struct IntakeChartView_Previews: PreviewProvider {
    static var previews: some View {
        IntakeChartView()
            .preferredColorScheme(.dark)
    }
}
