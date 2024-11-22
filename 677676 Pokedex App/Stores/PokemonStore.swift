//
//  PokemonService.swift
//  677676 Pokedex App
//
//

import Foundation
import Combine

class PokemonStore: ObservableObject {
    @Published var pokemons: Result<[PokemonModel], Error> = .failure(NSError(domain: "", code: 0, userInfo: nil))
    
    private var cancellable: AnyCancellable?
    
    init() {
        fetchPokemonData()
    }
    
    func fetchPokemonData() {
        cancellable = fetchPokemon()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.pokemons = .failure(error)
                case .finished:
                    break
                }
            }, receiveValue: { pokemons in
                self.pokemons = .success(pokemons)
            })
    }
    
    func fetchPokemon() -> AnyPublisher<[PokemonModel], Error> {
        Future { promise in
            Task {
                do {
                    // Limit the request to the first 151 Pokémon because those are the best
                    guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151") else {
                        throw NSError(domain: "Invalid URL", code: -1, userInfo: nil)
                    }
                    let urlRequest = URLRequest(url: url, timeoutInterval: 14)
                    let (data, _) = try await URLSession.shared.data(for: urlRequest)
                    let pokemonResponse = try JSONDecoder().decode(PokemonResponse.self, from: data)
                    let pokemons: [PokemonModel] = pokemonResponse
                        .results?
                        .compactMap { entity in
                            return PokemonModel.map(entity: entity)
                        } ?? []
                    promise(.success(pokemons))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

