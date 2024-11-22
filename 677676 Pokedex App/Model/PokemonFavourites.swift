//
//  PokemonFavourites.swift
//  677676 Pokedex App
//
//
import SwiftUI

class PokemonFavourites: ObservableObject {
    @Published private(set) var favoriteIDs: [Int] = []
    
    private let userDefaultsKey = "pokemonFavoriteIDs"

    // Singleton instance
    static let shared = PokemonFavourites()

    // Private initializer to enforce singleton usage
    private init() {
        loadFavorites()
    }

    // Add a Pokémon ID to favorites
    func add(_ pokemonID: Int) {
        guard !favoriteIDs.contains(pokemonID) else { return }
        favoriteIDs.append(pokemonID)
        saveFavorites()
    }

    // Remove a Pokémon ID from favorites
    func remove(_ pokemonID: Int) {
        favoriteIDs.removeAll { $0 == pokemonID }
        saveFavorites()
    }

    // Check if a Pokémon ID is in favorites
    func isFavorite(_ pokemonID: Int) -> Bool {
        favoriteIDs.contains(pokemonID)
    }

    // Save favorite IDs to UserDefaults
    private func saveFavorites() {
        do {
            let data = try JSONEncoder().encode(favoriteIDs)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("Failed to save favorites: \(error.localizedDescription)")
        }
    }

    // Load favorite IDs from UserDefaults
    private func loadFavorites() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return }
        do {
            favoriteIDs = try JSONDecoder().decode([Int].self, from: data)
        } catch {
            print("Failed to load favorites: \(error.localizedDescription)")
        }
    }
}

