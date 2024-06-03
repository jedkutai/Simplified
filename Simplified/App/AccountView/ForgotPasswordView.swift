//
//  ForgotPasswordView.swift
//  Simplified
//
//  Created by Jed Kutai on 6/1/24.
//

import SwiftUI

private enum FocusedField {
    case email
}


struct ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var submitting: Bool = false
    @State private var retry: Bool = false
    @State private var showExitSheet: Bool = false
    
    @FocusState private var focusedField: FocusedField?
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        enterEmail
            .fullScreenCover(isPresented: $showExitSheet) {
                submittedEmail
            }
    }
    
    var enterEmail: some View {
        NavigationStack {
            VStack {
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
                
                if retry {
                    Text("An error occurred, Please try again.")
                        .font(.subheadline)
                        .foregroundStyle(Color(.systemRed))
                }
                
                if submitting {
                    ProgressView()
                } else {
                    if Checks.isValidEmail(email) {
                        Button {
                            retry = false
                            submitting = true
                            Task {
                                do {
                                    try await AuthService.resetPassword(withEmail: email)
                                    showExitSheet = true
                                } catch {
                                    retry = true
                                }
                                submitting = false
                            }
                        } label: {
                            Text("Submit")
                                .foregroundStyle(Color(.systemBlue))
                        }
                    } else {
                        Text("Submit")
                            .foregroundStyle(Color(.systemGray))
                    }
                }
                
                
            }
            .navigationTitle("Forgot Password?")
            .navigationBarTitleDisplayMode(.inline)
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
        }
    }
    
    var submittedEmail: some View {
        NavigationStack {
            VStack {
                Text("If the email is in our system, you will receive a reset link.")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .padding()
                
                NavigationLink {
                    LoginView().navigationBarBackButtonHidden()
                } label: {
                    Text("Continue")
                        .foregroundStyle(Color(.systemBlue))
                }
            }
        }
    }
}

#Preview {
    ForgotPasswordView()
}
