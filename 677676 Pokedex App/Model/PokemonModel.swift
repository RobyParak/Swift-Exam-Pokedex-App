//
//  PokemonModel.swift
//  677676 Pokedex App
//
//
import Foundation

struct PokemonModel: Hashable, Codable {
    let id: Int
    let name: String
    let imageUrl: String
    var types: [String] = []
    let abilities: [String]
    var height: Double?
    var weight: Double?
    var baseExperience: Int?

    // Mapping function to convert from `PokemonEntity` to `PokemonModel`
    static func map(entity: PokemonEntity) -> PokemonModel {
        guard let url = entity.url, let id = extractId(from: url) else {
            fatalError("Invalid PokemonEntity data") // Fail-safe for debugging
        }
        return PokemonModel(
            id: id,
            name: entity.name?.capitalized ?? "Unknown",
            imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png",
            types: [],
            abilities: [],
            height: nil,
            weight: nil,
            baseExperience: nil
        )
    }

    // Helper function to extract Pokémon ID from the URL
    static func extractId(from url: String) -> Int? {
        url.split(separator: "/").last.flatMap { Int($0) }
    }
}
