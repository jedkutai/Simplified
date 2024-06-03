//
//  SearchResultArtistCell.swift
//  Simplified
//
//  Created by Jed Kutai on 6/2/24.
//

import SwiftUI
import MusicKit

struct SearchResultArtistCell: View {
    let artist: Artist
    
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        HStack {
            
            if let artwork = artist.artwork {
                ArtworkImage(artwork, width: 50, height: 50)
                    .clipShape(Circle())
                    .frame(width: 50, height: 50)
                    
            } else {
                Image(systemName: "questionmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(Color(.systemGray))
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text(artist.name)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                
                Text("Artist")
                    .font(.footnote)
                    .foregroundStyle(Color(.systemGray))
            }
            
            
            
            Spacer()
        }
    }
}

//#Preview {
//    SearchResultArtistCell()
//}
