//
//  pokemonModel.swift
//  677676 Pokedex App
//
//  Created by admin on 10/7/24.
//
struct PokemonModel: Hashable {
    let id: Int
    let name: String
    
    var imageUrl: String {
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
    }
    
    static func map(entity: PokemonEntity) -> PokemonModel {
        let id = extractId(from: entity.url!) ?? 0
        return PokemonModel(id: id, name: entity.name!.capitalized)
    }
    
    private static func extractId(from url: String) -> Int? {
        let components = url.split(separator: "/")
        return Int(components.last ?? "")
    }
}


