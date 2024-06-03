//
//  SimplifiedDirections.swift
//  Simplified
//
//  Created by Jed Kutai on 6/1/24.
//

import SwiftUI

struct SimplifiedDirections: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.vertical) {
                    Text("In order to properly use this app, you will need to do a few things:")
                        .multilineTextAlignment(.leading)
                        .padding(.bottom)
                        .padding(.horizontal)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    
                    ExplainedBlock(
                        iconName: "1.square",
                        header: "Create an Apple Music Account",
                        explanations: ["- Simplified is powered by Apple Music. If you already have an account, ignore this step."]
                    )
                    .padding(.horizontal)
                    
                    ExplainedBlock(
                        iconName: "2.square",
                        header: "Allow access to Apple Music Account",
                        explanations: ["- Simplified will not write over your Apple Music library."]
                    )
                    .padding(.horizontal)
                    .padding(.top)
                    
                    ExplainedBlock(
                        iconName: "3.square",
                        header: "Create a Simplified Account",
                        explanations: ["- Simplified will not write over your Apple Music library."]
                    )
                    .padding(.horizontal)
                    .padding(.top)
                    
                    
                    Link("Create Apple Music Account", destination: URL(string: "https://music.apple.com/us/browse")!)
                        .foregroundStyle(Color(.systemPink))
                        .padding(.top, 40)
                    
    
                }
            }
            .navigationTitle("Simplified")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        
                    } label: {
                        Text("Next")
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                    }
                }
            }
        }
        
    }
}

struct ExplainedBlock: View {
    let iconName: String
    let header: String
    let explanations: [String]
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                
                Text(header)
                    .fontWeight(.semibold)
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                
                Spacer()
            }
            
            if !explanations.isEmpty {
                ForEach(explanations, id: \.self) { explanation in
                    HStack {
                        Text(explanation)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                    .padding(.leading)
                }
            }
        }
        .foregroundStyle(colorScheme == .dark ? .white : .black)
    }
}

#Preview {
    SimplifiedDirections()
}
