//
//  UserInfoView.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 21/04/2025.
//

import SwiftUI

struct UserInfoView: View {
    @State private var age: Int = 25
    @State private var height: Int = 170
    @State private var weight: Int = 70
    @State private var fitnessLevel: String = "Beginner"
    
    let fitnessLevels = ["Beginner", "Intermediate", "Advanced"]

    var body: some View {
        ZStack {
            Color.fitspinBackground.ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Logo
                Image("FITSPIN_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180)
                    .padding(.top, 40)
                
                // Instruction
                Text("Please tell us more about you")
                    .font(.headline)
                    .foregroundColor(.fitspinTangerine)
                
                Spacer()
                
                // Input fields
                VStack(spacing: 16) {
                    StepperField(label: "Age", value: $age, range: 10...100)
                    StepperField(label: "Height (cm)", value: $height, range: 100...250)
                    StepperField(label: "Weight (kg)", value: $weight, range: 30...200)
                    
                    Menu {
                        ForEach(fitnessLevels, id: \.self) { level in
                            Button(level) { fitnessLevel = level }
                        }
                    } label: {
                        HStack {
                            Text(fitnessLevel)
                                .foregroundColor(.fitspinBackground)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.fitspinBackground)
                        }
                        .padding()
                        .background(Color.fitspinInputBG)
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                Spacer()
                
                // Confirm
                Button("Confirm") {
                    // Navigate to FitnessGoalsView
                }
                .buttonStyle(FPOutlineButtonStyle())
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

//A reusable stepper row with label +/– inside a rounded rectangle
private struct StepperField: View {
    let label: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.fitspinBackground)
            Spacer()
            HStack(spacing: 8) {
                Button { if value > range.lowerBound { value -= 1 }
                } label: {
                    Image(systemName: "minus.circle")
                        .font(.title3)
                        .foregroundColor(.fitspinBackground)
                }
                
                Text("\(value)")
                .font(.body)
                .frame(minWidth:32)
                
                Button { if value < range.upperBound { value += 1 }
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.title3)
                        .foregroundColor(.fitspinBackground)
                }
            }
            .foregroundColor(.fitspinBackground)
        }
        .padding()
        .background(Color.fitspinInputBG)
        .cornerRadius(8)
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UserInfoView()
                .preferredColorScheme(.dark)
        }
    }
}
