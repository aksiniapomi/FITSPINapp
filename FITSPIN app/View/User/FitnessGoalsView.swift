//
//  FitnessGoalsView.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 21/04/2025.
//

import SwiftUI

struct FitnessGoalsView: View {
    // allow multiple selection
    @State private var selectedGoals: Set<Goal> = []
    
    // define your goal options
    enum Goal: String, CaseIterable, Identifiable {
        case fatLoss   = "Fat Loss"
        case weightGain = "Weight Gain"
        case muscleGain = "Muscle Gain"
        case hydration  = "Hydration"
        case strengthTraining = "Strength Training"
        
        var id: String { rawValue }
    }
    
    var body: some View {
        ZStack {
            Color.fitspinBackground.ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Logo
                Image("FITSPIN_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180)
                    .padding(.top, 16)
                
                // Heading
                VStack(spacing: 4) {
                    Text("Select your fitness goal")
                        .font(.headline)
                        .foregroundColor(.fitspinYellow)
                    Text("You can select multiple goals")
                        .font(.subheadline)
                        .foregroundColor(.fitspinTangerine)
                }
                
                
                // Goal buttons, multiple-select radio list
                VStack(spacing: 16) {
                    ForEach(Goal.allCases) { goal in
                        Button {
                            // toggle membership
                            if selectedGoals.contains(goal) {
                                selectedGoals.remove(goal)
                            } else {
                                selectedGoals.insert(goal)
                            }
                        } label: {
                            HStack {
                                // radio circle
                                ZStack {
                                    Circle()
                                        .stroke(Color.fitspinTangerine, lineWidth: 2)
                                        .frame(width: 20, height: 20)
                                    if selectedGoals.contains(goal) {
                                        Circle()
                                            .fill(Color.fitspinTangerine)
                                            .frame(width: 12, height: 12)
                                    }
                                }
                                Text(goal.rawValue)
                                    .foregroundColor(.fitspinTangerine)
                                    .padding(.leading, 12)
                                Spacer()
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        selectedGoals.contains(goal)
                                        ? Color.fitspinTangerine
                                        : Color.fitspinTangerine,
                                        lineWidth: 2
                                    )
                                    .background(
                                        selectedGoals.contains(goal)
                                        ? Color.fitspinBlue
                                        : Color.clear
                                    )
                            )
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                // Confirm
                Button("Confirm") {
                    // handle selectedGoals
                    print("User chose: \(selectedGoals.map { $0.rawValue })")
                }
                .buttonStyle(FPOutlineButtonStyle())
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
    
    
    private func toggle(_ goal: Goal) {
        if selectedGoals.contains(goal) {
            selectedGoals.remove(goal)
        } else {
            selectedGoals.insert(goal)
        }
    }
}

struct FitnessGoalsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FitnessGoalsView()
                .preferredColorScheme(.dark)
        }
    }
}
