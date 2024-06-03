//
//  ContentView.swift
//  Simplified
//
//  Created by Jed Kutai on 6/1/24.
//

import SwiftUI
import MusicKit

struct ContentView: View {
    @State private var status = MusicAuthorization.currentStatus
    
    var body: some View {
        if status == .authorized {
            OpeningViewController()
//                .tint(Color(.systemPink))
                .tint(CustomColor.tint)
        } else {
            SimplifiedDirections()
//                .tint(Color(.systemPink))
                .tint(CustomColor.tint)
        }

    }
}

//#Preview {
//    ContentView()
//}
