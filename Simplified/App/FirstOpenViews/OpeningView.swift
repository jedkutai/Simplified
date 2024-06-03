//
//  OpeningView.swift
//  Simplified
//
//  Created by Jed Kutai on 6/1/24.
//

import SwiftUI

struct OpeningView: View {
    let screenWidth = UIScreen.main.bounds.width
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("Simplified Logo")
                
                Spacer()
                Spacer()
                
                NavigationLink {
                    LoginView()
                } label: {
                    Text("Login")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                        .padding(20)
                        
                }
                
                HStack {
                    Rectangle()
                        .frame(width: 30, height: 1)
                    
                    Text("or")
                    
                    Rectangle()
                        .frame(width: 30, height: 1)
                }
                .foregroundStyle(colorScheme == .dark ? .white : .black)
                
                NavigationLink {
                    CreateAccountView()
                } label: {
                    Text("Create Account")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                        .padding(20)
                }
                
                Spacer()
                Spacer()
                
            }
            .onAppear {
                Task {
                    do {
                        try await AuthService.signOut()
                    }
                }
            }
        }
    }
}

#Preview {
    OpeningView()
}
