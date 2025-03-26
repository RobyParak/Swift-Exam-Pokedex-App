//
//  PokemonService.swift
//  677676 Pokedex App
//
import Foundation
import Combine

class PokemonStore: ObservableObject {
    @Published var pokemons: Result<[PokemonModel], Error> = .failure(NSError(domain: "", code: 0, userInfo: nil))
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchPokemonData()
    }
    
    func fetchPokemonData() {
        fetchPokemon()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.pokemons = .failure(error)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] pokemons in
                self?.pokemons = .success(pokemons)
            })
            .store(in: &cancellables)
    }
    
    func fetchPokemon() -> AnyPublisher<[PokemonModel], Error> {
        Future { promise in
            Task {
                do {
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
    
    func fetchPokemonDetailsbyId(id: Int) -> AnyPublisher<PokemonModel, Error> {
        Future { promise in
            Task {
                do {
                    guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)") else {
                        throw NSError(domain: "Invalid URL", code: -1, userInfo: nil)
                    }
                    
                    let urlRequest = URLRequest(url: url, timeoutInterval: 14)
                    let (data, _) = try await URLSession.shared.data(for: urlRequest)
                    
                    let pokemonDetails = try JSONDecoder().decode(PokemonDetailsResponse.self, from: data)
                    
                    let pokemonModel = PokemonModel(
                        id: pokemonDetails.id,
                        name: pokemonDetails.name.capitalized,
                        imageUrl: pokemonDetails.sprites.frontDefault ??
                            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemonDetails.id).png",
                        types: pokemonDetails.types.map { $0.type.name },
                        abilities: [], // Add abilities parsing if needed
                        height: Double(pokemonDetails.height) / 10,
                        weight: Double(pokemonDetails.weight) / 10,
                        baseExperience: nil
                    )
                    
                    promise(.success(pokemonModel))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
