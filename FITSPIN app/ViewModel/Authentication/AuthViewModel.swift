//
//  AuthViewModel.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 23/04/2025.
//

import Foundation
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
  @Published var user: User?
  @Published var isLoading = false
  @Published var authError: String?

  private let service = AuthService.shared

  init() {
    service.addAuthStateListener { [weak self] user in
      self?.user = user
    }
  }

  func signUp(email: String, password: String) async {
    isLoading = true; authError = nil
    do {
      user = try await service.createUser(email: email, password: password)
    } catch {
      authError = error.localizedDescription
    }
    isLoading = false
  }

  func signIn(email: String, password: String) async {
    isLoading = true; authError = nil
    do {
      user = try await service.signIn(email: email, password: password)
    } catch {
      authError = error.localizedDescription
    }
    isLoading = false
  }

  func signOut() {
    do {
      try service.signOut()
      user = nil
    } catch {
      authError = error.localizedDescription
    }
  }
}
