//
//  FetchService.swift
//  Simplified
//
//  Created by Jed Kutai on 6/1/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct FetchService {
    static func fetchUserByUid(uid: String) async throws -> User {
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        return try snapshot.data(as: User.self)
    }
}
