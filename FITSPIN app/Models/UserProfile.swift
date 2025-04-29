//
//  UserProfile.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 27/04/2025.
//

import FirebaseFirestore

struct UserProfile: Codable, Identifiable {
    @DocumentID var id: String? //user's uid
    var age: Int
    var height: Int
    var weight: Int
    var fitnessLevel: String
    var goals: [String]
}
