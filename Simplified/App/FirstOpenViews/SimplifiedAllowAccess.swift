//
//  SimplifiedAllowAccess.swift
//  Simplified
//
//  Created by Jed Kutai on 6/1/24.
//

import SwiftUI
import MusicKit

struct SimplifiedAllowAccess: View {
    @State private var status = MusicAuthorization.currentStatus
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if status == .authorized {
            NavigationLink {
                OpeningView().navigationBarBackButtonHidden()
            } label: {
                Text("Final Step!")
                    .foregroundStyle(Color(.systemBlue))
            }
        } else {
            VStack {
                
                Text("Allow access to your music library to continue.")
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .font(.title.weight(.semibold))
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Button {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        if UIApplication.shared.canOpenURL(settingsURL) {
                            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                        }
                    }
                } label: {
                    Text("Open Settings")
                        .foregroundStyle(Color(.systemBlue))
                }
                
                Spacer()
            }
            .padding()
            .onAppear {
                Task {
                    status = await MusicAuthorization.request()
                }
            }
        }
    }
}

