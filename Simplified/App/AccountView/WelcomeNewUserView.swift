//
//  WelcomeNewUserView.swift
//  Simplified
//
//  Created by Jed Kutai on 6/1/24.
//

import SwiftUI

struct WelcomeNewUserView: View {
    let uid: String
    
    @State private var failed: Bool = false
    @State private var reloading: Bool = false
    
    @State private var user: User?
    
    var body: some View {
        if let user = self.user {
            NavigationStack {
                VStack {
                    Spacer()
                    
                    Text("Simplified Logo")
                    
                    Spacer()
                    
                    Text("Welcome!")
                        .font(.title2)
                    
                    Spacer()
                    
                    NavigationLink {
                        MainView(user: user).navigationBarBackButtonHidden()
                    } label: {
                        Text("Continue")
                            .foregroundStyle(Color(.systemBlue))
                    }
                    
                    Spacer()
                }
            }
        } else if failed {
            Button {
                user = nil
                failed = false
            } label: {
                Text("Reload")
            }
        } else {
            ProgressView()
                .onAppear {
                    onAppearActions()
                }
        }
    }
    
    private func onAppearActions() {
        Task {
            do {
                user = try await FetchService.fetchUserByUid(uid: uid)
            } catch {
                failed = true
            }
        }
    }
}
