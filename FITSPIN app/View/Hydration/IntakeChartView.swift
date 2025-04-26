//
//  IntakeChartView.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 23/04/2025.
//

import SwiftUI
import Charts

struct IntakeChartView: View {
    @EnvironmentObject private var hydVM: HydrationViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedMonth = Date()
    
    private var monthName: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "LLLL yyyy"
        return fmt.string(from: selectedMonth)
    }
    
    //Pull the VM’s published data for the currently selected month
    private var data: [DailyIntake] {
        hydVM.intakeHistory(for: selectedMonth)
    }
    
    var body: some View {
        ZStack {
            Color.fitspinBackground.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                
                HStack {
                    Spacer()
                    Button("Dismiss") {
                        dismiss()
                    }
                    .font(.headline)
                    .foregroundColor(.fitspinYellow)
                }
                
                Spacer()
                
                Text("Water Intake History")
                    .font(.title2).bold()
                    .foregroundColor(.fitspinBlue)
                
                // month selector
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
                
                // the chart
                Chart(data) { entry in
                    BarMark(
                        x: .value("Day", entry.date, unit: .day),
                        y: .value("Liters", entry.liters)
                    )
                    .foregroundStyle(Color.fitspinBlue.gradient)
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: 5)) {
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: .dateTime.day())
                            .foregroundStyle(Color.fitspinOffWhite)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) {
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
        }
        .onAppear {
            Task {
                // load this month’s data on first appear
                await hydVM.loadHistory(for: selectedMonth)
            }
        }
    }
    
    
    private func changeMonth(by months: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: months, to: selectedMonth) {
            selectedMonth = newDate
            Task { await hydVM.loadHistory(for: selectedMonth) }
        }
    }
    
}

struct IntakeChartView_Previews: PreviewProvider {
    static var previews: some View {
        IntakeChartView()
            .environmentObject(HydrationViewModel())
            .preferredColorScheme(.dark)
    }
}
