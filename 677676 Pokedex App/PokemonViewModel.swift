//
//  PokemonViewModel.swift
//  677676 Pokedex App
//
//  Created by admin on 10/7/24.
//

import Combine
import SwiftUI

class PokemonViewModel: ObservableObject {
    @Published var pokemonList: [PokemonModel] = []
    private var cancellable: AnyCancellable?
    
    func fetchPokemon() {
        cancellable = PokemonService.shared.fetchPokemon()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.pokemonList, on: self)
    }
}

struct PokemonListView: View {
    @StateObject private var viewModel = PokemonViewModel()

    var body: some View {
        List(viewModel.pokemonList) { pokemon in
            HStack {
                AsyncImage(url: URL(string: pokemon.imageUrl)) { image in
                    image.resizable()
                         .frame(width: 50, height: 50)
                } placeholder: {
                    ProgressView()
                }
                
                Text(pokemon.name)
                    .font(.headline)
            }
        }
        .onAppear {
            viewModel.fetchPokemon()
        }
    }
}

#Preview {
    PokemonListView()
}

