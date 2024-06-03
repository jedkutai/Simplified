//
//  X.swift
//  Simplified
//
//  Created by Jed Kutai on 6/1/24.
//

import SwiftUI
import Combine
import MusicKit

enum SongReplayType {
    case none
    case replayAll
    case replayOne
}

@MainActor
class X: ObservableObject {
    
    @Published var musicPlayer = ApplicationMusicPlayer.shared
    @Published var tick: Bool = false
    @Published var reloadLibrary: Bool = true
    
    // music queue stuff
    @Published var loadedSong: Song?
    @Published var history: [Song] = []
    @Published var manualQueue: [Song] = []
    @Published var automaticQueue: [Song] = []
    @Published var repeatQueue: [Song] = []
    
    // music playback
    @Published var playing: Bool = false
    @Published var manuallyStopped: Bool = true
    @Published var playbackState: MusicPlayer.PlaybackStatus = .stopped
    @Published var songReplayType: SongReplayType = .none
    
    func playSong(song: Song) {
        Task {
            do {
                musicPlayer.queue = [song]
                try await musicPlayer.play()
                self.loadedSong = song
                self.manuallyStopped = false
                
                
                // update repeat queue functions
            } catch {
                print("Failed to play song: \(error)")
            }
        }
    }
    
    func pauseSong() {
        self.musicPlayer.stop()
        self.manuallyStopped = true
    }
    
    func loadedSongFinishedPlaying() {
        if let loadedSong = self.loadedSong {
            
            self.history.append(loadedSong)
            
            if self.songReplayType == .replayOne {
                self.playSong(song: loadedSong)
            } else if let nextSong = self.manualQueue.first {
                self.playSong(song: nextSong)
                self.manualQueue.remove(at: 0)
            } else if let nextSong = self.automaticQueue.first {
                self.playSong(song: nextSong)
                self.automaticQueue.remove(at: 0)
            } else if self.songReplayType == .replayAll {
                if let nextSong = self.automaticQueue.first {
                    self.playSong(song: nextSong)
                    self.automaticQueue = self.repeatQueue[1...].compactMap({ $0 })
                } else {
                    self.manuallyStopped = true
                }
            } else {
                self.manuallyStopped = true
            }
        }
    }
    
    func queueSong(song: Song) {
        
        self.manualQueue.append(song)
        
        print("\(song.title) queued.")
        
        var position = 0
        for track in self.manualQueue {
            position += 1
            print("\(position): \(track.title)")
        }
    }
    
}
