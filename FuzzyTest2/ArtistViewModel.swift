//
//  ArtistViewModel.swift
//  FuzzyTest2
//
//  Created by Michael Isasi on 1/13/20.
//  Copyright © 2020 Michael Isasi. All rights reserved.
//
import Foundation

public enum FilterType: Int {
    case standard
    case isasi
    case lev
}

struct ArtistViewModel {
    
    public init() {
        searchText = ""
        self.filteredArtists = Artists.shared.artists
    }
    private var filter: FilterType = .standard
    
    private var filteredArtists: [String]
    
    private var removeSpec = false {
        didSet {
            updateFilteredResults()
        }
    }
    
    public mutating func toggleSpec() {
        self.removeSpec.toggle()
    }
    
    private var searchText: String {
        didSet {
            self.updateFilteredResults()
        }
    }
    
    private var tolorance = 3 {
        didSet {
            self.updateFilteredResults()
        }
    }
    
    public mutating func update(tolorance: Int) {
        guard self.tolorance != tolorance else { return }
        self.tolorance = tolorance
    }
    
    func clean(string: String) -> String {
        if removeSpec {
            let unsafeChars = CharacterSet.alphanumerics.inverted
            return string.lowercased().components(separatedBy: unsafeChars).joined(separator: "")
        }
        
        return string.lowercased()
    }
    
    private mutating func updateFilteredResults() {
        
        let _searchText = clean(string: searchText)
        guard !_searchText.isEmpty else {
            self.filteredArtists = Artists.shared.artists
            return
        }
        
        func updateStandardFilter() {
            self.filteredArtists = Artists.shared.artists.filter{ self.clean(string: $0).contains(_searchText)}
        }
        
        func updateIsasiFuzzyMatch() {
            self.filteredArtists = []
            
            let results = Artists.shared.artists.map { ($0, self.clean(string: $0).fuzzyContains(string: _searchText, toloranceLevel: self.tolorance)) }.filter { $0.1.0 }.sorted { $0.1.1 > $1.1.1}
            self.filteredArtists = results.map {$0.0}
        }
        
        func updateLevMatch() {
            let results = Artists.shared.artists.map { ($0, self.clean(string: $0).containsLevenshtein(bStr: _searchText, toloranceLevel: self.tolorance)) }.filter { $0.1.0 }.sorted { $0.1.1  < $1.1.1 }
            self.filteredArtists = results.map { $0.0 }
        }
        
        if self.searchText.isEmpty {
            filteredArtists = Artists.shared.artists
        } else {
            switch self.filter {
            case .standard:
                updateStandardFilter()
            case .isasi:
                updateIsasiFuzzyMatch()
            case .lev:
                updateLevMatch()
            }
        }
    }
    
    
    
    mutating func update(filter tag: Int) {
        self.filter = FilterType(rawValue: tag)!
        self.updateFilteredResults()
    }
    
    mutating func update(searchText: String) {
        self.searchText = searchText.lowercased()
    }
    
    func artist(for row: Int) -> String {
        return self.filteredArtists[row]
    }
    
    var artistCount: Int {
        return self.filteredArtists.count
    }
}
