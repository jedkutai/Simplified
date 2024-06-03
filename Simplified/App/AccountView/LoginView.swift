//
//  LoginView.swift
//  Simplified
//
//  Created by Jed Kutai on 6/1/24.
//

import SwiftUI

private enum FocusedField {
    case email
    case password
    
}

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var uid: String = ""
    
    @State private var showPassword: Bool = false
    @State private var submitting: Bool = false
    @State private var invalidLogin: Bool = false
    @State private var showWelcomeSheet: Bool = false
    
    @FocusState private var focusedField: FocusedField?
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Simplified Logo")
                
                Spacer()
                
                
                TextField("Email", text: $email)
                    .focused($focusedField, equals: .email)
                    .disabled(submitting)
                    .textContentType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding().padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(Color(.systemGray6))
                            .padding(.horizontal)
                    )
                
                HStack {
                    if showPassword {
                        TextField("Password (Min. 8 Characters)", text: $password)
                            .focused($focusedField, equals: .password)
                            .disabled(submitting)
                            .textContentType(.newPassword)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                    } else {
                        SecureField("Password (Min. 8 Characters)", text: $password)
                            .focused($focusedField, equals: .password)
                            .disabled(submitting)
                            .textContentType(.newPassword)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                    }
                    
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye" : "eye.slash")
                            .foregroundStyle(Color(.black))
                    }
                }
                .padding().padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(Color(.systemGray6))
                        .padding(.horizontal)
                )
                HStack {
                    Spacer()
                    
                    NavigationLink {
                        ForgotPasswordView()
                    } label: {
                        Text("Forgot Password?")
                            .font(.subheadline)
                            .foregroundStyle(Color(.systemBlue))
                    }
                }
                .padding(.horizontal, 40)
                
                if invalidLogin {
                    Text("Invalid Login")
                        .font(.subheadline)
                        .foregroundStyle(Color(.systemRed))
                }
                Spacer()
                
                if self.canSubmit() {
                    Button {
                        Task {
                            invalidLogin = false
                            submitting = true
                            do {
                                let result = try await AuthService.login(withEmail: email, password: password)
                                
                                if result.contains("Error:") {
                                    invalidLogin = true
                                } else {
                                    uid = result
                                    showWelcomeSheet = true
                                }
                            } catch {
                                invalidLogin = true
                            }
                            submitting = false
                        }
                    } label: {
                        Text("Login")
                            .foregroundStyle(Color(.systemBlue))
                    }
                } else {
                    Text("Login")
                        .foregroundStyle(Color(.systemGray))
                }
                
                Spacer()
                
                
            }
            .onSubmit {
                switch focusedField {
                case .email:
                    focusedField = .password
                case .password:
                    focusedField = nil
                case nil:
                    focusedField = nil
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button {
                        focusedField = nil
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                }
            }
            .fullScreenCover(isPresented: $showWelcomeSheet) {
                WelcomeUserView(uid: uid)
            }
        }
    }
    
    private func canSubmit() -> Bool {
        if email.isEmpty {
            return false
        }
        
        if password.isEmpty {
            return false
        }
        
        if submitting {
            return false
        }
        
        return true
    }
}

#Preview {
    LoginView()
}
