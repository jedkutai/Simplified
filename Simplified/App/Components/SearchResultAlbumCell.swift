//
//  SearchResultAlbumCell.swift
//  Simplified
//
//  Created by Jed Kutai on 6/2/24.
//

import SwiftUI
import MusicKit

struct SearchResultAlbumCell: View {
    let album: Album
    
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        HStack {
            if let artwork = album.artwork {
                ArtworkImage(artwork, width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .frame(width: 50, height: 50)
                    .border(Color(.systemGray6))
            } else {
                Image(systemName: "questionmark.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(Color(.systemGray))
            }
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(album.title)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    if let contentRating = album.contentRating {
                        if contentRating == .explicit {
                            ExplicitTag()
                                .padding(.trailing)
                        }
                    }
                    
                }
                
                Text(album.artistName)
                    .foregroundStyle(Color(.systemGray))
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Text("Album")
                    .font(.footnote)
                    .foregroundStyle(Color(.systemGray))
            }
            
            Spacer()
        }
    }
}

//#Preview {
//    SearchResultAlbumCell()
//}
