//
//  pokemonModel.swift
//  677676 Pokedex App
//
//  Created by admin on 10/7/24.
//
import Foundation

struct PokemonModel: Identifiable {
    let id: Int
    let name: String
    let type: String

    // Computed property to generate the image URL dynamically
    var imageUrl: String {
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
    }
}
