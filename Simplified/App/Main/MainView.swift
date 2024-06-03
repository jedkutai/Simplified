//
//  MainView.swift
//  Simplified
//
//  Created by Jed Kutai on 6/1/24.
//

import SwiftUI
import MusicKit

enum ShownView {
    case home
    case search
    
}

struct MainView: View {
    @State var user: User
    
    
    @State private var shownView: ShownView = .home
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var x: X
    
    @State private var musicViewShown: MusicViewShown = .songs
    
    let tabIconWidth: CGFloat = 20
    
    @State private var temporarySignOutToggle = false
    
    var body: some View {
        NavigationStack {
            VStack {
                switch shownView {
                case .home:
                    MainMusicView(musicViewShown: $musicViewShown)
                    
                case .search:
                    MainSearchView()
                }
                
                
                    
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Group {
                        switch shownView {
                        case .home:
                            Button {
                                withAnimation {
                                    shownView = .search
                                }
                            } label: {
                                Image(systemName: "square.on.square")
                                
                            }
                        case .search:
                            Button {
                                withAnimation {
                                    shownView = .home
                                }
                            } label: {
                                Image(systemName: "square.on.square")
                            }
                        }
                    }
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                }
                
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button {
//                        temporarySignOutToggle.toggle()
//                    } label: {
//                        Text("Sign Out")
//                            .foregroundStyle(CustomColor.tint)
//                    }
//                }
                
                    if let currentSong = x.loadedSong {
                        ToolbarItem(placement: .topBarTrailing) {
                            NowPlayingMiniCell(song: currentSong)
                        }
                    }
            }
            .fullScreenCover(isPresented: $temporarySignOutToggle) {
                SignOutView()
            }
        }
        .onChange(of: x.tick) { _ in
            x.playbackState = x.musicPlayer.state.playbackStatus
            
            if !x.manuallyStopped {
                if x.playbackState == .paused || x.playbackState == .stopped {
                    x.loadedSongFinishedPlaying()
                }
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                x.tick.toggle()
            }
        }
        .onAppear {
            x.tick.toggle()
        }
        
    }
    
    
}
