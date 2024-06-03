//
//  OpeningViewController.swift
//  Simplified
//
//  Created by Jed Kutai on 6/1/24.
//

import SwiftUI

enum OpeningViewState {
    case loading
    case finished
}

struct OpeningViewController: View {
    @State private var user: User?
    
    @State private var openingViewState: OpeningViewState = .loading
    @EnvironmentObject var x: X
    
    var body: some View {
        switch openingViewState {
        case .loading:
            VStack {
                Text("Simplified Logo")
            }
                .onAppear {
                    self.onAppearActions()
                }
        case .finished:
            if let user = self.user {
                MainView(user: user)
            } else {
                OpeningView()
            }
        }
    }
    
    private func onAppearActions() {
        // try to load a new user
        Task {
            do {
                self.user = try await AuthService.automaticLogin()
            } catch {
                self.user = nil
            }
            
            openingViewState = .finished
        }
        
        
    }
}
