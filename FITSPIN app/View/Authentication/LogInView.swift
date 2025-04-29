//
//  LogInView.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 21/04/2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var authVM: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    
    @State private var showValidationAlert = false
    
    
    var body: some View {
        ZStack {
            Color.fitspinBackground.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 30) {
                    // logo
                    Image("FITSPIN_logo")
                        .resizable().scaledToFit().frame(width: 180)
                        .padding(.top, 40)
                    
                    // header
                    VStack(spacing: 8) {
                        Text("Welcome Back!")
                            .font(.headline).foregroundColor(.fitspinYellow)
                        Text("Log in to continue")
                            .font(.subheadline).foregroundColor(.fitspinTangerine)
                    }
                    
                    // fields
                    VStack(spacing: 16) {
                        TextField("Email", text: $email)
                            .textContentType(.emailAddress)
                            .disableAutocorrection(true)
                            .padding()
                            .background(Color.fitspinFieldBlue)
                            .cornerRadius(8)
                            .foregroundColor(.fitspinOffWhite)
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .foregroundColor(.fitspinOffWhite)
                            .background(Color.fitspinFieldBlue)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    // show any auth error
                    if let err = authVM.authError {
                        Text(err)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    // sign-in button
                    Button {
                        // validation
                        guard !email.isEmpty, !password.isEmpty else {
                            showValidationAlert = true
                            return
                        }
                        Task {
                            await authVM.signIn(email: email, password: password)
                        }
                    } label: {
                        Text(authVM.isLoading ? "Logging In…" : "Log In")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(FPButtonStyle())
                    .alert("Please fill in both email and password to log in", isPresented: $showValidationAlert) {
                                Button("OK", role: .cancel) { }
                              }
                    
                    // forgot / switch to register
                    HStack {
                        Button("Forgot Password?") {
                            
                        }
                        Spacer()
                        NavigationLink("Sign Up", destination: RegisterView())
                            .foregroundColor(.fitspinTangerine)
                            .font(.footnote).bold()
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LoginView()
                .environmentObject(AuthViewModel())
            // .preferredColorScheme(.dark)
        }
    }
}
