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
    @State private var selectedEntry: DailyIntake?
    
    private var monthName: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "LLLL yyyy"
        return fmt.string(from: selectedMonth)
    }
    
    // Pull the VM’s published data for the currently selected month
    private var data: [DailyIntake] {
        hydVM.intakeHistory(for: selectedMonth)
    }
    
    var body: some View {
        ZStack {
            Color.fitspinBackground.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                // Dismiss
                HStack {
                    Spacer()
                    Button("Dismiss") {
                        dismiss()
                    }
                    .font(.headline)
                    .foregroundColor(.fitspinYellow)
                }
                
                Text("Water Intake History")
                    .font(.title2).bold()
                    .foregroundColor(.fitspinBlue)
                
                // Month selector
                HStack {
                    Button { changeMonth(by: -1) } label: {
                        Image(systemName: "chevron.left")
                    }
                    .buttonStyle(.borderless)
                    .foregroundColor(.fitspinYellow)
                    
                    Spacer()
                    
                    Text(monthName)
                        .font(.headline)
                        .foregroundColor(.fitspinYellow)
                    
                    Spacer()
                    
                    Button { changeMonth(by: +1) } label: {
                        Image(systemName: "chevron.right")
                    }
                    .buttonStyle(.borderless)
                    .foregroundColor(.fitspinYellow)
                }
                
                // Chart
                Chart(data) { entry in
                    BarMark(
                        x: .value("Day", entry.date, unit: .day),
                        y: .value("Liters", entry.liters)
                    )
                    .foregroundStyle(Color.fitspinBlue.gradient)
                    // annotation on the selected bar
                    .annotation(position: .top) {
                        if let sel = selectedEntry,
                           Calendar.current.isDate(sel.date, inSameDayAs: entry.date)
                        {
                            VStack(spacing: 4) {
                                Text(sel.date, format: .dateTime.day().month(.abbreviated))
                                    .font(.caption2).bold()
                                Text("\(sel.liters, specifier: "%.1f") L")
                                    .font(.caption2)
                            }
                            .padding(6)
                            .background(.thinMaterial)
                            .cornerRadius(6)
                            .offset(y: -4)
                        }
                    }
                }
                // X-axis every 5 days
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: 5)) { mark in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: .dateTime.day())
                            .foregroundStyle(Color.fitspinOffWhite)
                    }
                }
                // Y-axis on leading edge, show “1.0 L”
                .chartYAxis {
                    AxisMarks(position: .leading) { mark in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel {
                            let val = mark.as(Double.self) ?? 0
                            Text("\(val, specifier: "%.1f") L")
                        }
                        .foregroundStyle(Color.fitspinOffWhite)
                    }
                }
                // Axis labels
                .chartXAxisLabel("Day", position: .bottom, alignment: .center)
                .chartYAxisLabel("Liters", position: .leading, alignment: .center)
                .frame(height: 300)
                .padding(.bottom)
                // Interactive tooltip overlay
                .chartOverlay { proxy in
                    GeometryReader { geo in
                        // resolve the plot‐area rectangle
                        let plotArea: CGRect = geo[proxy.plotAreaFrame]
                        
                        Rectangle()
                            .fill(Color.clear)
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        // compute x relative to the chart’s plot area
                                        let xPos = value.location.x - plotArea.origin.x
                                        if let date: Date = proxy.value(atX: xPos) {
                                            selectedEntry = data.first {
                                                Calendar.current.isDate($0.date, inSameDayAs: date)
                                            }
                                        }
                                    }
                                    .onEnded { _ in
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            selectedEntry = nil
                                        }
                                    }
                            )
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            Task { await hydVM.loadHistory(for: selectedMonth) }
        }
    }
    
    // Helpers
    
    private func changeMonth(by months: Int) {
        if let newDate = Calendar.current.date(
            byAdding: .month,
            value: months,
            to: selectedMonth
        ) {
            selectedMonth = newDate
            Task { await hydVM.loadHistory(for: newDate) }
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



