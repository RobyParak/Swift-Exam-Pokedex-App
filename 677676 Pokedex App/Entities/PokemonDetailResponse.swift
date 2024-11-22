//
//  PokemonDetailResponse.swift
//  677676 Pokedex App
//
//
import Foundation

struct PokemonDetailResponse: Decodable {
    let types: [TypeEntry]
    let abilities: [AbilityEntry]
    let height: Int
    let weight: Int
    let baseExperience: Int

    struct TypeEntry: Decodable {
        let type: TypeInfo
        struct TypeInfo: Decodable {
            let name: String
        }
    }

    struct AbilityEntry: Decodable {
        let ability: AbilityInfo
        struct AbilityInfo: Decodable {
            let name: String
        }
    }
}
