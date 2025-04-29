//
//  ResetPasswordView.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 29/04/2025.
//

import Foundation
import SwiftUI

struct ResetPasswordView: View {
    @EnvironmentObject private var authVM: AuthViewModel
    @Environment(\.dismiss)   private var dismiss

    @State private var email     = ""
    @State private var showAlert = false

    var body: some View {
        ZStack {
           
            Color.fitspinBackground
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Enter your email to reset your password")
                    .font(.subheadline)
                    .foregroundColor(.fitspinOffWhite)
                    .multilineTextAlignment(.center)

                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .padding()
                    .foregroundColor(.fitspinOffWhite)
                    .background(Color.fitspinFieldBlue)
                    .cornerRadius(8)
                    .padding(.horizontal)

                Button("Send Reset Link") {
                    Task {
                        await authVM.resetPassword(for: email)
                        showAlert = true
                    }
                }
                .buttonStyle(FPButtonStyle())
                .disabled(email.isEmpty)

                Spacer()
            }
            .padding(.top, 40)
            .alert(
                authVM.authError ?? authVM.passwordResetMessage ?? "",
                isPresented: $showAlert
            ) {
                Button("OK", role: .cancel) {
                    authVM.authError = nil
                    authVM.passwordResetMessage = nil
                }
            }
        }
        .navigationTitle("Reset Password")
        .navigationBarTitleDisplayMode(.inline)

        //hide default back button and add "< Account"
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Log In")
                    }
                    .foregroundColor(.fitspinYellow)
                }
            }
        }
    }
}

