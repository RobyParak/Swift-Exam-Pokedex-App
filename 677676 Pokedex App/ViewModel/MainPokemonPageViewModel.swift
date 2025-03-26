//
//  MainPokemonPageView.swift
//  677676 Pokedex App
//
import Foundation
import Combine

class MainPokemonPageViewModel: ObservableObject {
    @Published var search: String = ""
    @Published var pokemons: Result<[PokemonModel], Error> = .failure(NSError(domain: "", code: 0, userInfo: nil))
    @Published var isLoading: Bool = false
    
    private let pokemonStore: PokemonStore
    private var cancellables = Set<AnyCancellable>()
    
    init(pokemonStore: PokemonStore = PokemonStore()) {
        self.pokemonStore = pokemonStore
        
        pokemonStore.$pokemons
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.pokemons = result
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        fetchPokemons()
    }
    
    func refreshData() {
        fetchPokemons()
    }
    
    private func fetchPokemons() {
        isLoading = true
        pokemonStore.fetchPokemonData()
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
