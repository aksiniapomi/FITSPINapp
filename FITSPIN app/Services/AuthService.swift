//
//  AuthService.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 23/04/2025.
//

import Foundation
import FirebaseAuth

//A singleton “backend” interface for authentication
final class AuthService {
    static let shared = AuthService()
    private init() {}
    
    //Listen continuously to auth‐state changes
    @discardableResult
    func addAuthStateListener(_ listener: @escaping (User?) -> Void)
    -> AuthStateDidChangeListenerHandle
    {
        return Auth.auth()
            .addStateDidChangeListener { _, user in
                listener(user)
            }
    }
    
    //Create a new user
    func createUser(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return result.user
    }
    
    //Sign in an existing user
    func signIn(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user
    }
    
    //Sign out the current user
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
