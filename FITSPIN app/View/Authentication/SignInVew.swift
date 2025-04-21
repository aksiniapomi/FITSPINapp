//
//  SignInVew.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 21/04/2025.
//

import SwiftUI

class SignInViewModel: ObservableObject {
    @Published var isLoading = false
}

struct SignInView: View {
    @StateObject private var vm = SignInViewModel()
    
    var body: some View {
        ZStack {
            Color.fitspinBackground.ignoresSafeArea()
            
            VStack {
                
                Spacer().frame(height:230)
                
                Image("FITSPIN_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                
                Spacer().frame(height:40)
                
                //buttons next to each other with equal width
                HStack(spacing:16){
                    Button("Sign Up") {
                        // navigate to RegisterView
                    }
                    .buttonStyle(FPOutlineTangerineButtonStyle())
                    .frame(maxWidth: .infinity)
                    
                    Button("Log In") {
                        // navigate to LoginView
                    }
                    .buttonStyle(FPOutlineButtonStyle())
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: 300)
         
                Spacer()
            }
            .padding(.horizontal)
        }
        //.navigationBarHidden(true)
    }
}

#Preview {
    SignInView()
}
