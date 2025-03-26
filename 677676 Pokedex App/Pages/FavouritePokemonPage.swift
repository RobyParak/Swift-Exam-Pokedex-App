//
//  FavouritePokemonPage.swift
//  677676 Pokedex App
//
import SwiftUI

struct FavouritePokemonPage: View {
    @EnvironmentObject var pokemonFavourites: PokemonFavourites
    @EnvironmentObject var pokemonStore: PokemonStore
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    
                    // Content
                    if pokemonFavourites.favoriteIDs.isEmpty {
                        emptyStateView
                    } else {
                        switch pokemonStore.pokemons {
                        case .success(let allPokemons):
                            let favoritePokemons = pokemonFavourites.favoriteIDs.compactMap { id in
                                allPokemons.first { $0.id == id }
                            }
                            .sorted { $0.id < $1.id }
                            .filter {
                                searchText.isEmpty ||
                                $0.name.lowercased().contains(searchText.lowercased()) ||
                                String($0.id).contains(searchText)
                            }
                            
                            if favoritePokemons.isEmpty {
                                noResultsView
                            } else {
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                                    ForEach(favoritePokemons, id: \.id) { pokemon in
                                        NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                                            PokemonCell(pokemon: pokemon)
                                        }
                                    }
                                }
                                .padding()
                            }
                            
                        case .failure(let error):
                            errorStateView(errorMessage: error.localizedDescription)
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            Image(systemName: "heart.fill")
                .font(.system(size: 50))
                .foregroundColor(.red)
                .padding()
            Text("No favorite Pokémon yet!")
                .font(.headline)
            Text("Tap the heart icon on a Pokémon to add it here.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding(.top, 50)
    }
    
    private var noResultsView: some View {
        VStack {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.gray)
                .padding()
            Text("No matching Pokémon found")
                .font(.headline)
            Text("Try a different search term")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding(.top, 50)
    }
    
    private func errorStateView(errorMessage: String) -> some View {
        VStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
                .font(.largeTitle)
                .padding()
            Text("Oops! Something went wrong.")
                .font(.headline)
                .foregroundColor(.red)
            Text(errorMessage)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}
