//
//  PokemonViewModel.swift
//  677676 Pokedex App
//
//
import Combine
import Foundation

class PokemonViewModel: ObservableObject {
    @Published var selectedPokemon: PokemonModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    private let pokemon: PokemonModel

    init(pokemon: PokemonModel) {
        self.pokemon = pokemon
        fetchPokemonDetails(for: pokemon)
    }

    func fetchPokemonDetails(for pokemon: PokemonModel) {
        isLoading = true
        errorMessage = nil

        let urlString = "https://pokeapi.co/api/v2/pokemon/\(pokemon.id)"
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL."
            isLoading = false
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: PokemonDetailResponse.self, decoder: JSONDecoder())
            .map { detailResponse in
                var updatedPokemon = pokemon
                updatedPokemon.types = detailResponse.types.map { $0.type.name }
                updatedPokemon.abilities = detailResponse.abilities.map { $0.ability.name }
                updatedPokemon.height = Double(detailResponse.height) / 10.0
                updatedPokemon.weight = Double(detailResponse.weight) / 10.0
                updatedPokemon.baseExperience = detailResponse.baseExperience
                return updatedPokemon
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    if let urlError = error as? URLError {
                        self?.errorMessage = "Network error: \(urlError.localizedDescription)"
                    } else if let decodingError = error as? DecodingError {
                        self?.errorMessage = "Data decoding error: \(decodingError.localizedDescription)"
                    } else {
                        self?.errorMessage = "Unknown error: \(error.localizedDescription)"
                    }
                case .finished:
                    break
                }
                self?.isLoading = false
            }, receiveValue: { [weak self] updatedPokemon in
                self?.selectedPokemon = updatedPokemon
            })
            .store(in: &cancellables)
    }
}


