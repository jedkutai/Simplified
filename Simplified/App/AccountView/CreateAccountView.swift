//
//  CreateAccountView.swift
//  Simplified
//
//  Created by Jed Kutai on 6/1/24.
//

import SwiftUI

private enum FocusedField {
    case email
    case password
    case passwordConfirm
    
}

struct CreateAccountView: View {
    @State private var uid: String = ""
    @State private var nickname: String = ""
    
    @State private var email: String = ""
    
    @State private var password: String = ""
    @State private var passwordConfirm: String = ""
    
    @State private var showPassword: Bool = false
    @State private var submitting: Bool = false
    
    @State private var emailAlreadyUsed: Bool = false
    
    @State private var showWelcomePage: Bool = false
    
    @FocusState private var focusedField: FocusedField?
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                Text("Simplified Logo")
                    .font(.title.weight(.semibold))
                    .padding(.top)
                
                VStack(spacing: 20) {
                    
//                    Text("Create Account")
//                        .font(.title.weight(.semibold))
//                        .padding(.top)
                    
                    
                    if emailAlreadyUsed {
                        Text("Email already in use.")
                            .font(.subheadline)
                            .foregroundStyle(Color(.systemRed))
                    }
                    
                    TextField("Email", text: $email)
                        .focused($focusedField, equals: .email)
                        .disabled(submitting)
                        .textContentType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .padding().padding(.horizontal)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(Color(.systemGray6))
                                    .padding(.horizontal)
                                
                                if Checks.isValidEmail(self.email) {
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color(.green))
                                        .padding(.horizontal)
                                }
                                
                            }
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
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(Color(.systemGray6))
                                .padding(.horizontal)
                            
                            if Checks.isValidPassword(self.password) {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(.green))
                                    .padding(.horizontal)
                            }
                            
                        }
                    )
                    
                    HStack {
                        if showPassword {
                            TextField("Confirm Password", text: $passwordConfirm)
                                .focused($focusedField, equals: .passwordConfirm)
                                .disabled(submitting)
                                .textContentType(.newPassword)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                        } else {
                            SecureField("Confirm Password", text: $passwordConfirm)
                                .focused($focusedField, equals: .passwordConfirm)
                                .disabled(submitting)
                                .textContentType(.newPassword)
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
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(Color(.systemGray6))
                                .padding(.horizontal)
                            
                            if !password.isEmpty {
                                if password == passwordConfirm {
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color(.green))
                                        .padding(.horizontal)
                                }
                            }
                            
                        }
                    )
                    
                    if self.canSubmitAccount() && !submitting {
                        Button {
                            submitting = true
                            emailAlreadyUsed = false
                            Task {
                                do {
                                    let result = try await AuthService.createAccount(email: email, password: password)
                                    
                                    if result.contains("Error:") {
                                        if result == ErrorText.emailAlreadyUsed {
                                            emailAlreadyUsed = true
                                        }
                                    } else {
                                        uid = result
                                        showWelcomePage = true
                                    }
                                } catch {
                                    print("\(error.localizedDescription)")
                                }
                                
                                submitting = false
                            }
                        } label: {
                            Text("Create Account")
                                .font(.title2.weight(.semibold))
                                .foregroundStyle(Color(.systemBlue))
                                .padding(20)
                            
                        }
                    } else if submitting {
                        Text("Create Account")
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(Color(.systemGray))
                            .padding(20)
                    } else {
                        Text("Create Account")
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(Color(.systemGray))
                            .padding(20)
                    }
                    
                    
                }
            }
            .onSubmit {
                switch focusedField {
                case .email:
                    focusedField = .password
                case .password:
                    focusedField = .passwordConfirm
                case .passwordConfirm:
                    focusedField = nil
                case nil:
                    print("focusedField nil")
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
            .fullScreenCover(isPresented: $showWelcomePage) {
                WelcomeNewUserView(uid: uid)
            }
            
        }
    }
    
    private func canSubmitAccount() -> Bool {
        
        return Checks.canSubmitAccountCreation(email: self.email, password: self.password, passwordConfirm: self.passwordConfirm)
    }
}

#Preview {
    CreateAccountView()
}
