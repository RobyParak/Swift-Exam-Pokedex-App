//
//  MainPokemonPageView.swift
//  677676 Pokedex App
//
import Foundation
import Combine

class MainPokemonPageViewModel: ObservableObject {
    @Published var search: String = ""
    @Published var pokemons: Result<[PokemonModel], Error> = .failure(NSError(domain: "", code: 0, userInfo: nil))
    
    private let pokemonStore: PokemonStore
    private var cancellables = Set<AnyCancellable>()
    
    init(pokemonStore: PokemonStore) {
        self.pokemonStore = pokemonStore
        fetchPokemons()
    }
    
    func refreshData() async {
        do {
            let newPokemons = try await fetchPokemonsAsync() // Fetch Pokémon asynchronously
            DispatchQueue.main.async {
                self.pokemons = .success(newPokemons)
            }
        } catch {
            DispatchQueue.main.async {
                self.pokemons = .failure(error)
            }
        }
    }
    
    private func fetchPokemons() {
        pokemonStore.fetchPokemon()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.pokemons = .failure(error)
                    print("Error fetching Pokémon: \(error)")
                }
            }, receiveValue: { pokemons in
                self.pokemons = .success(pokemons)
                print("Fetched Pokémon: \(pokemons.count) found.")
            })
            .store(in: &cancellables)
    }
    
    private func fetchPokemonsAsync() async throws -> [PokemonModel] {
        return try await withCheckedThrowingContinuation { continuation in
            pokemonStore.fetchPokemon()
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        continuation.resume(throwing: error)
                    }
                }, receiveValue: { pokemons in
                    continuation.resume(returning: pokemons)
                })
                .store(in: &cancellables)
        }
    }
    
    var filteredPokemons: [PokemonModel] {
        guard case .success(let pokemons) = pokemons else {
            print("No Pokémon available.")
            return []
        }
        let filtered = pokemons.filter {
            search.isEmpty || $0.name.lowercased().contains(search.lowercased())
        }
        print("Filtered Pokémon: \(filtered.count) matching '\(search)'.")
        return filtered
    }
}
