//
//  PokemonViewModel.swift
//  677676 Pokedex App
//
//
import Foundation
import Combine

class PokemonViewModel: ObservableObject {
    @Published var pokemonDetails: PokemonModel?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let pokemonStore: PokemonStore
    private var cancellables = Set<AnyCancellable>()
    
    init(pokemonStore: PokemonStore = PokemonStore()) {
        self.pokemonStore = pokemonStore
    }
    
    func fetchDetails(for id: Int) {
        isLoading = true
        errorMessage = nil
        pokemonDetails = nil
        
        pokemonStore.fetchPokemonDetailsbyId(id: id)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                        print("Error fetching Pokémon details: \(error)")
                    }
                },
                receiveValue: { [weak self] details in
                    self?.pokemonDetails = details
                    print("Successfully fetched Pokémon: \(details.name)")
                }
            )
            .store(in: &cancellables)
    }
    
    func clearDetails() {
        pokemonDetails = nil
        errorMessage = nil
    }
    
    func toggleFavorite(pokemon: PokemonModel) {
        if PokemonFavourites.shared.isFavorite(pokemon.id) {
            PokemonFavourites.shared.remove(pokemon.id)
        } else {
            PokemonFavourites.shared.add(pokemon.id)
        }
        if let currentDetails = pokemonDetails, currentDetails.id == pokemon.id {
            objectWillChange.send()
        }
    }
    
    func isFavorite(pokemon: PokemonModel) -> Bool {
        return PokemonFavourites.shared.isFavorite(pokemon.id)
    }
}
