//
//  ProfileService.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 27/04/2025.
//

import FirebaseAuth
import FirebaseFirestore

final class ProfileService {
    private let db = Firestore.firestore()
    private var uid: String? { Auth.auth().currentUser?.uid }
    
    //Loads this user’s profile doc (if it exists) or returns nil
    func loadProfile() async throws -> UserProfile? {
        guard let uid = uid else { return nil }
        let doc = try await db
            .collection("users")
            .document(uid)
            .getDocument()
        return try doc.data(as: UserProfile.self)
    }
    
    //Saves (or overwrites) the profile
    func saveProfile(_ profile: UserProfile) async throws {
        guard let uid = uid else { throw URLError(.userAuthenticationRequired) }
        var copy = profile
        copy.id = uid
        try db
            .collection("users")
            .document(uid)
            .setData(from: copy, merge: true)
    }
}
