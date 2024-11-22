//
//  PokemonModel.swift
//  677676 Pokedex App
//
//

import Foundation

struct PokemonModel: Hashable {
    let id: Int
    let name: String

    var imageUrl: String {
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
    }

    // Additional details
    var types: [String] = []
    var abilities: [String] = []
    var height: Double? // in meters
    var weight: Double? // in kilograms
    var baseExperience: Int?

    // Mapping function to convert from PokemonEntity to PokemonModel
    static func map(entity: PokemonEntity) -> PokemonModel {
        guard let url = entity.url, let id = extractId(from: url) else {
            fatalError("Invalid PokemonEntity data") // Fail-safe for debugging
        }
        return PokemonModel(id: id, name: entity.name?.capitalized ?? "Unknown")
    }

    // Helper function to extract Pokémon ID from the URL
    private static func extractId(from url: String) -> Int? {
        // Split the URL by "/" and attempt to convert the last segment to an Int
        url.split(separator: "/").last.flatMap { Int($0) }
    }
}
