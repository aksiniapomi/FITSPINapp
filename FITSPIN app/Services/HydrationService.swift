//
//  HydrationService.swift
//  FITSPIN app
//
//  Created by Xenia Uni Account on 26/04/2025.
//

import FirebaseFirestore
import FirebaseAuth

enum HydrationServiceError: Error {
    case notSignedIn
}

final class HydrationService {
    private let db = Firestore.firestore()
    
    private var uid: String {
        get throws {
            guard let u = Auth.auth().currentUser?.uid else {
                throw HydrationServiceError.notSignedIn
            }
            return u
        }
    }
    
    //Write the new intake for a given day
    func set(intake: Double, for date: Date) async throws {
        let userId = try uid
        let id = isoDateFormatter.string(from: date)
        let ref = db
            .collection("users")
            .document(userId)
            .collection("hydrationLog")
            .document(id)
        
        try await ref.setData([
            "date": Timestamp(date: date),
            "intake": intake
        ], merge: true)
    }
    
    //Read the intake for a specific date
    func intake(on date: Date) async throws -> Double {
        let userId = try uid
        let id = isoDateFormatter.string(from: date)
        let snap = try await db
            .collection("users")
            .document(uid)
            .collection("hydrationLog")
            .document(id)
            .getDocument()
        return snap.data()?["intake"] as? Double ?? 0
    }
    
    //Read a month’s worth of records
    func intakeHistory(monthOf date: Date) async throws -> [DailyIntake] {
        let userId = try uid
        let cal = Calendar.current
        let comps = cal.dateComponents([.year, .month], from: date)
        let start = cal.date(from: comps)!
        let end = cal.date(byAdding: .month, value: 1, to: start)!
        
        let query = db
            .collection("users")
            .document(userId)
            .collection("hydrationLog")
            .whereField("date", isGreaterThanOrEqualTo: Timestamp(date: start))
            .whereField("date", isLessThan: Timestamp(date: end))
        let snaps = try await query.getDocuments()
        return snaps.documents.compactMap { doc in
            guard
                let ts = doc["date"] as? Timestamp,
                let lit = doc["intake"] as? Double
            else { return nil }
            return DailyIntake(date: ts.dateValue(), liters: lit)
        }
    }
    
    private var isoDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = TimeZone(abbreviation: "UTC")
        return f
    }()
}
