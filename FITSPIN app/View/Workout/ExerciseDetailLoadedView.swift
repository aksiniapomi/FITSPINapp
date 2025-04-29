//
//  ExerciseDetailLoadedView.swift
//  FITSPIN app
//
//  Created by Derya Baglan on 24/04/2025.
//

import SwiftUI
import AVKit

struct ExerciseDetailLoadedView: View {
    let workout: Workout
    @EnvironmentObject var completedStore: CompletedWorkoutsStore
    @State private var isMarked = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                //Video
                if let url = workout.videoURL {
                    VideoPlayer(player: AVPlayer(url: url))
                        .frame(height: 280)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal)
                }
                
                //Title + Category
                VStack(alignment: .leading, spacing: 12) {
                    Text(workout.name)
                        .font(.title.bold())
                        .foregroundColor(.white)
                    
                    HStack {
                        Text(workout.category.uppercased())
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.15))
                            .cornerRadius(8)
                        
                        Spacer()
                        
                        Text("\(workout.equipment.count) Equipment")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                //Equipment
                if !workout.equipment.isEmpty {
                    sectionCard(title: "You'll Need") {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(workout.equipment, id: \.self) { item in
                                    EquipmentIcon(name: item)
                                }
                            }
                        }
                    }
                }
                
                //Description
                sectionCard(title: "Description") {
                    Text(cleanHTML(workout.description))
                        .foregroundColor(.white)
                }
                
                //Tips
                if !workout.comments.isEmpty {
                    sectionCard(title: "Tips") {
                        ForEach(workout.comments, id: \.self) { tip in
                            Text("💡 \(tip)")
                                .foregroundColor(.white)
                        }
                    }
                }
                
                //Timer
                sectionCard(title: "Timer") {
                    ExerciseTimerView(
                        exerciseName: workout.name,
                        equipment: workout.equipment
                    )
                    .frame(height: 150)
                }
                
                //Completion Button Feedback
                if isMarked {
                    Label("Workout Logged!", systemImage: "checkmark.seal.fill")
                        .foregroundColor(.green)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(12)
                        .padding(.horizontal)
                } else {
                    Button(action: {
                        completedStore.add(workout)
                        isMarked = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            isMarked = false
                        }
                    }) {
                        Label("Mark as Completed", systemImage: "checkmark.circle.fill")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.fitspinTangerine)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(Color.fitspinBackground.ignoresSafeArea())
    }
    
    private func sectionCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.fitspinYellow)
            content()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .padding(.horizontal)
    }
    
    //HTML Cleaner
    private func cleanHTML(_ html: String) -> String {
        html.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

