//
//  ExplicitTag.swift
//  Simplified
//
//  Created by Jed Kutai on 6/2/24.
//

import SwiftUI

struct ExplicitTag: View {
    var body: some View {
        Image(systemName: "e.square.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 10)
//            .foregroundStyle(Color(.systemPink))
            .foregroundStyle(CustomColor.tint)
    }
}

#Preview {
    ExplicitTag()
}
