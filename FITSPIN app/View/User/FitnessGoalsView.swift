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
                Image("fitspin_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180)
                    .padding(.top, 40)

                // Heading
                VStack(spacing: 8) {
                    Text("Select your fitness goal")
                        .font(.headline)
                        .foregroundColor(.fitspinYellow)
                    Text("You can select multiple goals")
                        .font(.subheadline)
                        .foregroundColor(.fitspinTangerine)
                }
        

                // Goal buttons
                VStack(spacing: 16) {
                    ForEach(Goal.allCases) { goal in
                        Button {
                            toggle(goal)
                        } label: {
                            HStack {
                                Text(goal.rawValue)
                                    .foregroundColor(selectedGoals.contains(goal)
                                                      ? .fitspinBackground
                                                      : .fitspinTangerine)
                                Spacer()
                                if selectedGoals.contains(goal) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.fitspinBackground)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        selectedGoals.contains(goal)
                                        ? Color.fitspinYellow
                                        : Color.fitspinTangerine,
                                        lineWidth: 2
                                    )
                                    .background(
                                        selectedGoals.contains(goal)
                                        ? Color.fitspinYellow
                                        : Color.clear
                                    )
                            )
                        }
                    }
                }
                .padding(.horizontal)
                

                // Confirm
                Button("Confirm") {
                    // Save and navigate on
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
