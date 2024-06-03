//
//  SignOutSheetView.swift
//  Simplified
//
//  Created by Jed Kutai on 6/1/24.
//

import SwiftUI

struct SignOutView: View {
    
    let screenWidth = UIScreen.main.bounds.width
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                Text("Are you sure that you want to sign out?")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .multilineTextAlignment(.center)
                    
                
                Spacer()
                
                HStack {
                    NavigationLink {
                        OpeningView().navigationBarBackButtonHidden()
                    } label: {
                        Text("Sign Out")
                            .foregroundStyle(Color(.systemRed))
                    }
                    .frame(width: screenWidth * 0.5)
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Return")
                            .foregroundStyle(Color(.systemGray))
                    }
                    .frame(width: screenWidth * 0.5)
                }
            }
            .padding()
        }
    }
}

#Preview {
    SignOutView()
}
