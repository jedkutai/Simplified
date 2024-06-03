//
//  MainSearchView.swift
//  Simplified
//
//  Created by Jed Kutai on 6/1/24.
//

import SwiftUI
import MusicKit

enum SearchFilter {
    case topResults
    case artists
    case albums
    case songs
    
    var text: String {
        switch self {
        case .topResults:
            return "Top Results"
        case .artists:
            return "Artists"
        case .albums:
            return "Albums"
        case .songs:
            return "Songs"
        }
    }
}

struct MainSearchView: View {
    @EnvironmentObject var x: X
    
    @State private var searchText: String = ""
    
    @State private var topResults: [MusicCatalogSearchResponse] = []
    @State private var artistsResults: [MusicCatalogSearchResponse] = []
    @State private var albumsResults: [MusicCatalogSearchResponse] = []
    @State private var songsResults: [MusicCatalogSearchResponse] = []
    
    @State private var failed: Bool = false
    
    @State private var showFilters: Bool = false
    @State private var searchFilter: SearchFilter = .topResults
    
    var body: some View {
        NavigationStack {
            VStack {
                if showFilters {
                    SearchFilterPicker(searchFilter: $searchFilter)
                        .padding(.horizontal)
                }
                
                List {
                    switch searchFilter {
                    case .topResults:
                        ForEach(topResults, id: \.self) { result in
                            ForEach(result.artists, id: \.id) { artist in
                                NavigationLink {
                                    
                                } label: {
                                    SearchResultArtistCell(artist: artist)
                                }
                            }
                            
                            ForEach(result.albums, id: \.id) { album in
                                NavigationLink {
                                    
                                } label: {
                                    SearchResultAlbumCell(album: album)
                                }
                            }
                            
                            ForEach(result.songs, id: \.id) { song in
                                SearchResultSongCell(song: song)
                                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                        Button {
                                            x.queueSong(song: song)
                                        } label: {
                                            Label("Queue Song", systemImage: "text.line.last.and.arrowtriangle.forward")
                                                .foregroundStyle(.white)
                                        }
                                        .tint(CustomColor.tint)
                                    }
                                    
                            }
                            
                            
                            
                            
                        }
                    case .artists:
                        ForEach(artistsResults, id: \.self) { result in
                            
                            ForEach(result.artists, id: \.id) { artist in
                                NavigationLink {
                                    
                                } label: {
                                    SearchResultArtistCell(artist: artist)
                                }
                            }
                        }
                    case .albums:
                        ForEach(albumsResults, id: \.self) { result in
                            
                            ForEach(result.albums, id: \.id) { album in
                                NavigationLink {
                                    
                                } label: {
                                    SearchResultAlbumCell(album: album)
                                }
                            }
                            
                        }
                    case .songs:
                        ForEach(songsResults, id: \.self) { result in
                            ForEach(result.songs, id: \.id) { song in
                                SearchResultSongCell(song: song)
                                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                        Button {
                                            x.queueSong(song: song)
                                        } label: {
                                            Label("Queue Song", systemImage: "text.line.last.and.arrowtriangle.forward")
                                                .foregroundStyle(.white)
                                        }
                                        .tint(CustomColor.tint)
                                    }
                            }
                            
                        }
                    }
                    
                }
                .searchable(text: $searchText, prompt: "Artists, Albums and Songs")
                .autocorrectionDisabled(true)
                .listStyle(.plain)
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
            .onChange(of: searchText) { _ in
                if searchText.isEmpty {
                    topResults = []
                } else {
                    searchTopResults(term: searchText)
                }
                
                if showFilters {
                    withAnimation {
                        showFilters = false
                    }
                }
                
                if searchFilter != .topResults {
                    searchFilter = .topResults
                }
            }
            .onSubmit(of: .search) {
                if !searchText.isEmpty {
                    searchArtists(term: searchText)
                    searchAlbums(term: searchText)
                    searchSongs(term: searchText)
                    
                    withAnimation {
                        showFilters = true
                    }
                }
            }
        }
    }
    
    private func searchTopResults(term: String) {
        Task {
            do {
                let searchRequest = MusicCatalogSearchRequest(term: term, types: [Song.self, Album.self, Artist.self])
                let response = try await searchRequest.response()

                // Process search results
                self.topResults = [response]

                if topResults.isEmpty {
                    print("No results found for the search term.")
                }
            } catch {
                print("Failed to perform search: \(error.localizedDescription)")
                failed = true
            }
        }
    }
    
    private func searchArtists(term: String) {
        Task {
            do {
                let searchRequest = MusicCatalogSearchRequest(term: term, types: [Artist.self])
                let response = try await searchRequest.response()

                // Process search results
                self.artistsResults = [response]

                if artistsResults.isEmpty {
                    print("No artists found for the search term.")
                }
            } catch {
                print("Failed to perform search: \(error.localizedDescription)")
                failed = true
            }
        }
    }
    
    private func searchAlbums(term: String) {
        Task {
            do {
                let searchRequest = MusicCatalogSearchRequest(term: term, types: [Album.self])
                let response = try await searchRequest.response()

                // Process search results
                self.albumsResults = [response]

                if albumsResults.isEmpty {
                    print("No albums found for the search term.")
                }
            } catch {
                print("Failed to perform search: \(error.localizedDescription)")
                failed = true
            }
        }
    }
    
    private func searchSongs(term: String) {
        Task {
            do {
                let searchRequest = MusicCatalogSearchRequest(term: term, types: [Song.self])
                let response = try await searchRequest.response()

                // Process search results
                self.songsResults = [response]

                if songsResults.isEmpty {
                    print("No songs found for the search term.")
                }
            } catch {
                print("Failed to perform search: \(error.localizedDescription)")
                failed = true
            }
        }
    }
}

struct SearchFilterPicker: View {
    @Binding var searchFilter: SearchFilter
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack {
            SearchFilterPickerButton(searchFilter: $searchFilter, targetFilter: .topResults)
            
            Spacer()
            
            SearchFilterPickerButton(searchFilter: $searchFilter, targetFilter: .artists)
            
            Spacer()
            
            SearchFilterPickerButton(searchFilter: $searchFilter, targetFilter: .albums)
            
            Spacer()
            
            SearchFilterPickerButton(searchFilter: $searchFilter, targetFilter: .songs)
        }
    }
}

struct SearchFilterPickerButton: View {
    @Binding var searchFilter: SearchFilter
    let targetFilter: SearchFilter
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        if searchFilter == targetFilter {
            Text(targetFilter.text)
                .foregroundStyle(.white)
                .font(.footnote.weight(.semibold))
                .minimumScaleFactor(0.1)
                .lineLimit(1)
                .frame(height: 25)
                .padding(5)
                .background(
                    RoundedRectangle(cornerRadius: 5)
//                        .foregroundStyle(Color(.systemPink))
                        .foregroundStyle(CustomColor.tint)
                )
            
        } else {
            Button {
                withAnimation {
                    searchFilter = targetFilter
                }
            } label: {
                Text(targetFilter.text)
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .font(.footnote.weight(.semibold))
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .frame(height: 25)
                    .padding(5)
            }
        }
    }
}

//#Preview {
//    MainSearchView()
//}
