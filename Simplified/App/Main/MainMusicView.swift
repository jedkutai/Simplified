//
//  MainMusicView.swift
//  Simplified
//
//  Created by Jed Kutai on 6/1/24.
//

import SwiftUI
import MusicKit

enum MusicViewShown {
    case albums
    case artists
    case playlists
    case songs
    
}



private enum FocusedField {
    case searchBar
}

struct MainMusicView: View {
    @Binding var musicViewShown: MusicViewShown
    
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var focusedField: FocusedField?
    
    @EnvironmentObject var x: X
    
    var body: some View {
        NavigationStack {
            VStack {
                
                
                Picker("", selection: $musicViewShown) {
                    
                    Text("Albums")
                        .tag(MusicViewShown.albums)
                        
                    
                    Text("Artists")
                        .tag(MusicViewShown.artists)
                    
                    Text("Playlists")
                        .tag(MusicViewShown.playlists)
                    
                    Text("Songs")
                        .tag(MusicViewShown.songs)
                    
                    
                    
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
//                switch musicViewShown {
//                case .albums:
//                    AlbumsView()
//                case .artists:
//                    ArtistsView()
//                case .playlists:
//                    PlaylistsView()
//                case .songs:
//                    SongsView()
//                }
                    
                Spacer()
                
            }
            .navigationTitle("Simplified") // x.loadedSong?.title ?? "Simplified"
            .navigationBarTitleDisplayMode(.large)
//            .onAppear {
//                if x.reloadLibrary {
//                    x.appOpenActions()
//                }
//            }
        }
    }
    
    
    
    
}
