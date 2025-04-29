//
//  AuthViewModel.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 23/04/2025.
//
import Foundation
import FirebaseAuth
import FirebaseFirestore


@MainActor
class AuthViewModel: ObservableObject {
    @Published private(set) var user: User?
    @Published var isLoading = false
    @Published var authError: String?
    
    private let service = AuthService.shared
    
    init() {
        service.addAuthStateListener { [weak self] user in
            Task { @MainActor in
                self?.user = user
            }
        }
    }
    
    func signUp(fullName: String, email: String, password: String) async {
        isLoading = true
        authError = nil
        defer { isLoading = false }
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = fullName
            try await changeRequest.commitChanges()
            
            self.user = Auth.auth().currentUser
        } catch {
            authError = "\(error.localizedDescription)"
        }
    }
    
    func signIn(email: String, password: String) async {
        isLoading = true
        authError = nil
        defer { isLoading = false }
        
        do {
            user = try await service.signIn(email: email, password: password)
        } catch {
            authError = "\(error.localizedDescription)"
        }
    }
    
    func signOut() {
        do {
            try service.signOut()
            user = nil
        } catch {
            authError = "\(error.localizedDescription)"
        }
    }
    
    func deleteAccount() async {
        isLoading = true
        authError = nil
        defer { isLoading = false }
        
        guard let user = Auth.auth().currentUser else {
            authError = "No user is currently signed in"
            return
        }
        let uid = user.uid
        let db = Firestore.firestore()
        
        do {
            //delete every doc in each sub-collection
            for sub in ["completedWorkouts", "favourites", "hydrationLog"] {
                let collRef = db
                    .collection("users")
                    .document(uid)
                    .collection(sub)
                let snap = try await collRef.getDocuments()
                for doc in snap.documents {
                    try await doc.reference.delete()
                }
            }
            
            //delete the users/{uid} document itself
            try await db.collection("users").document(uid).delete()
            
            //delete the Auth user
            try await user.delete()
            self.user = nil
            
        } catch {
            authError = error.localizedDescription
        }
    }
}
