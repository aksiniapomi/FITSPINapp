//
//  ExerciseTimerView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 26/04/2025.
//

import SwiftUI

struct ExerciseTimerView: View {
    @State private var remainingTime: Int = 30
    @State private var selectedTime: Int = 30
    @State private var isRunning: Bool = false
    @State private var timer: Timer?
    
    let exerciseName: String
    let equipment: [String]
    
    var body: some View {
        VStack(spacing: 8) {
            //Time Display
            Text(timeString(from: remainingTime))
                .font(.system(size: 28, weight: .medium, design: .monospaced))
                .foregroundColor(.white)
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.2))
                .cornerRadius(12)
            
            //Slider
            VStack(spacing: 4) {
                Text("Duration: \(selectedTime) sec")
                    .font(.caption2)
                    .foregroundColor(.gray)
                
                Slider(value: Binding(
                    get: { Double(selectedTime) },
                    set: { newValue in
                        selectedTime = Int(newValue)
                        if !isRunning {
                            remainingTime = selectedTime
                        }
                    }
                ), in: 10...180, step: 5)
                .accentColor(.fitspinYellow)
            }
            
            //Controls
            HStack(spacing: 20) {
                Button(action: reset) {
                    Image(systemName: "gobackward")
                }
                
                Button(action: toggleTimer) {
                    Image(systemName: isRunning ? "pause.fill" : "play.fill")
                }
                
                Button(action: stopNow) {
                    Image(systemName: "stop.fill")
                }
            }
            .font(.body)
            .foregroundColor(.white)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
            .background(Color.black.opacity(0.1))
            .cornerRadius(10)
        }
        .padding(8)
        .background(Color.black.opacity(0.2))
        .cornerRadius(16)
    }
    
    
    //Timer Logic
    private func toggleTimer() {
        isRunning.toggle()
        isRunning ? startTimer() : stopTimer()
    }
    
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func stopNow() {
        stopTimer()
        remainingTime = 0
        isRunning = false
    }
    
    private func reset() {
        stopTimer()
        remainingTime = selectedTime
        isRunning = false
        
    }
    
    private func timeString(from seconds: Int) -> String {
        String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
}
