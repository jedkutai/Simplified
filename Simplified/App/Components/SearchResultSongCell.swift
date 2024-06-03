//
//  SearchResultSongCell.swift
//  Simplified
//
//  Created by Jed Kutai on 6/2/24.
//

import SwiftUI
import MusicKit

struct SearchResultSongCell: View {
    let song: Song
    
    
    @State private var tapped = false
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var x: X
    var body: some View {
        Button {
            withAnimation {
                tapped = true
            }
            x.playSong(song: song)
        } label: {
            HStack {
                if let artwork = song.artwork {
                    ArtworkImage(artwork, width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .frame(width: 50, height: 50)
                        .border(tapped ? CustomColor.tint : Color(.clear), width: 3)
                } else {
                    Image(systemName: "questionmark.square.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(Color(.systemGray))
                        .border(tapped ? CustomColor.tint : Color(.clear), width: 3)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    HStack {
                        Text(song.title)
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                        if let contentRating = song.contentRating {
                            if contentRating == .explicit {
                                ExplicitTag()
                                    .padding(.trailing)
                            }
                        }
                        
                    }
                    
                    Text(song.artistName)
                        .foregroundStyle(Color(.systemGray))
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Text("Song")
                        .font(.footnote)
                        .foregroundStyle(Color(.systemGray))
                }
                
                
                
                Spacer()
                
                
                // if song is in library, show a checkmark
            }
            .onChange(of: tapped) { _ in
                if tapped {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            tapped = false
                        }
                    }
                }
            }
            
        }
    }
}
