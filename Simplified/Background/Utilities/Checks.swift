//
//  Checks.swift
//  Simplified
//
//  Created by Jed Kutai on 6/1/24.
//

import Foundation

struct Checks {
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8 && !password.contains(" ")
    }
    
    static func canSubmitAccountCreation(email: String, password: String, passwordConfirm: String) -> Bool {
        
        if !self.isValidEmail(email) {
            return false
        }
        
        if !self.isValidPassword(password) {
            return false
        }
        
        if password != passwordConfirm {
            return false
        }
        
        return true
    }
}
