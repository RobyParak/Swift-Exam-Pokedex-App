//
//  PokemonDetailResponse.swift
//  677676 Pokedex App
//
//
import Foundation

struct PokemonDetailsResponse: Codable {
    let id: Int
    let name: String
    let weight: Int
    let height: Int
    let types: [PokemonType]
    let stats: [PokemonStat]
    let sprites: PokemonSprites
    
    struct PokemonType: Codable {
        let slot: Int
        let type: TypeName
    }
    
    struct TypeName: Codable {
        let name: String
    }
    
    struct PokemonStat: Codable {
        let baseStat: Int
        let stat: StatName
        
        enum CodingKeys: String, CodingKey {
            case baseStat = "base_stat"
            case stat
        }
    }
    
    struct StatName: Codable {
        let name: String
    }
    
    struct PokemonSprites: Codable {
        let frontDefault: String?
        let frontShiny: String?
        
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
            case frontShiny = "front_shiny"
        }
    }
}
