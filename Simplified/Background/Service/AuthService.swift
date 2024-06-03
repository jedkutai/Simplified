//
//  AuthService.swift
//  Simplified
//
//  Created by Jed Kutai on 6/1/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct AuthService {
    static func uploadUserData(uid: String, email: String) async {
        let user = User(id: uid, email: email.lowercased())
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
        try? await Firestore.firestore().collection("users").document(uid).setData(encodedUser)
    }
    
    
    @MainActor
    static func createAccount(email: String, password: String) async throws -> String {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let uid = result.user.uid
            
            await self.uploadUserData(uid: uid, email: email)
            
            if let user = Auth.auth().currentUser {
                try await user.sendEmailVerification()
            }
            
            return uid
        } catch {
            return "Error: \(error.localizedDescription)"
        }
    }
    
    @MainActor
    static func login(withEmail email: String, password: String) async throws -> String {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            let uid = result.user.uid
            
            return uid
        } catch {
            print("DEBUG: \(error.localizedDescription)")
            return "Error: \(error.localizedDescription)"
        }
        
    }
    
    static func automaticLogin() async throws -> User? {
        var loggedInUser: User?
        
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            do {
                loggedInUser = try await FetchService.fetchUserByUid(uid: uid)
            } catch {
                loggedInUser = nil
            }
        }
        
        return loggedInUser
    }
    
    static func signOut() async throws {
        try Auth.auth().signOut()
    }
    
    static func resetPassword(withEmail email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    static func deleteAccount(withEmail email: String, password: String) async throws {
        do {
            if let user = Auth.auth().currentUser {
                let userDoc = Firestore.firestore().collection("users").document(user.uid)
                try await userDoc.delete()
                try await user.delete()
            }
        } catch {
            print("failed to delete account")
        }
    }
}
