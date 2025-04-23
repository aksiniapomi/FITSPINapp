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

  var body: some View {
    ZStack {
      Color.fitspinBackground.ignoresSafeArea()
      ScrollView {
        VStack(spacing: 30) {
          // logo
          Image("fitspin_logo")
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
              .background(Color.fitspinInputBG)
              .cornerRadius(8)

            SecureField("Password", text: $password)
              .padding()
              .background(Color.fitspinInputBG)
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
            Task {
              await authVM.signIn(email: email, password: password)
            }
          } label: {
            Text(authVM.isLoading ? "Logging In…" : "Log In")
              .frame(maxWidth: .infinity)
          }
          .buttonStyle(FPButtonStyle())
          .disabled(email.isEmpty || password.isEmpty || authVM.isLoading)

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
        .preferredColorScheme(.dark)
    }
  }
}
