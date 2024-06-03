//
//  NowPlayingMiniCell.swift
//  Simplified
//
//  Created by Jed Kutai on 6/2/24.
//

import SwiftUI
import MusicKit

struct NowPlayingMiniCell: View {
    let song: Song
    
    @State private var showNowPlayingSheet: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var x: X
    
    private let artDimension: CGFloat = 40
    private let buttonDimension: CGFloat = 30
    
    var body: some View {
        HStack {

            Button {
                showNowPlayingSheet.toggle()
            } label: {
                Group {
                    if let artwork = song.artwork {
                        ArtworkImage(artwork, width: artDimension, height: artDimension)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .frame(width: artDimension, height: artDimension)
                            .border(Color(.systemGray6))
                    } else {
                        Image(systemName: "square.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: artDimension, height: artDimension)
                            .foregroundStyle(Color(.systemGray))
                    }
                }
            }
            
            Group {
                if x.playbackState == .playing {
                    Button {
                        withAnimation {
                            x.pauseSong()
                        }
                    } label: {
                        Image(systemName: "pause.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: buttonDimension, height: buttonDimension)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                    }
                } else {
                    Button {
                        Task {
                            do {
                                try await x.musicPlayer.play()
                            } catch {
                                print("cant resume music")
                            }
                        }
                        
                    } label: {
                        Image(systemName: "play.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: buttonDimension, height: buttonDimension)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                    }
                }
            }
            
        }
        .sheet(isPresented: $showNowPlayingSheet) {
            
        }
    }
}
