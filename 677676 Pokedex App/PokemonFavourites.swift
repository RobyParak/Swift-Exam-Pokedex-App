//
//  PokemonFavourites.swift
//  677676 Pokedex App
//
//  Created by admin on 10/7/24.
//

import Foundation

class PokemonFavourites: ObservableObject {
    @Published private(set) var favoriteIDs: [Int] = []
    
    private let userDefaultsKey = "pokemonFavoriteIDs"

    // Singleton instance (optional)
    static let shared = PokemonFavourites()

    private init() {
        loadFavorites()
    }

    // Add a Pokémon ID to favorites
    func add(_ pokemonID: Int) {
        if !favoriteIDs.contains(pokemonID) {
            favoriteIDs.append(pokemonID)
            saveFavorites()
        }
    }

    // Remove a Pokémon ID from favorites
    func remove(_ pokemonID: Int) {
        favoriteIDs.removeAll { $0 == pokemonID }
        saveFavorites()
    }

    // Check if a Pokémon ID is in favorites
    func isFavorite(_ pokemonID: Int) -> Bool {
        return favoriteIDs.contains(pokemonID)
    }

    // Save favorite IDs to UserDefaults
    private func saveFavorites() {
        UserDefaults.standard.set(favoriteIDs, forKey: userDefaultsKey)
    }

    // Load favorite IDs from UserDefaults
    private func loadFavorites() {
        if let savedIDs = UserDefaults.standard.array(forKey: userDefaultsKey) as? [Int] {
            favoriteIDs = savedIDs
        }
    }
}
