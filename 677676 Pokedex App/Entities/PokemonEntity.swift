//
//  PokemonEntity.swift
//  677676 Pokedex App
//
//

import Foundation

struct PokemonEntity: Codable{
    let name: String?
    let url: String?
}

struct PokemonResponse: Codable{
    let count: Int?
    let next: String?
    let previous: String?
    let results: [PokemonEntity]?
}
