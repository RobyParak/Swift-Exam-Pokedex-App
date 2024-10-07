//
//  PokemonService.swift
//  677676 Pokedex App
//
//  Created by admin on 10/7/24.
//

import Foundation
import Combine

class PokemonService {
    static let shared = PokemonService()
    
    private init() {} // Singleton pattern to ensure one instance of the service
    
    func fetchPokemon(limit: Int = 151) -> AnyPublisher<[PokemonModel], Error> {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: PokemonResponse.self, decoder: JSONDecoder())
            .map { response in
                response.results.compactMap { apiResult -> PokemonModel? in
                    guard let id = self.extractId(from: apiResult.url) else { return nil }
                    let imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
                    return PokemonModel(id: id, name: apiResult.name.capitalized, type: "Unknown", imageUrl: imageUrl)
                }
            }
            .eraseToAnyPublisher()
    }
    
    // Helper method to extract Pokemon ID from URL
    private func extractId(from url: String) -> Int? {
        let components = url.split(separator: "/")
        return Int(components.last ?? "")
    }
}

struct PokemonResponse: Codable {
    let results: [PokemonAPIResult]
}

struct PokemonAPIResult: Codable {
    let name: String
    let url: String
}
