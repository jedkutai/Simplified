//
//  User.swift
//  Simplified
//
//  Created by Jed Kutai on 6/1/24.
//

import Foundation
import Firebase
import FirebaseFirestore

struct User: Identifiable, Hashable, Codable {
    let id: String
    var email: String
}
