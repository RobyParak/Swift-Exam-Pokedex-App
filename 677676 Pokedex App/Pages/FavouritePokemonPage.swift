//
//  FavouritePokemonPage.swift
//  677676 Pokedex App
//
import SwiftUI

struct FavouritePokemonPage: View {
    @EnvironmentObject var pokemonFavourites: PokemonFavourites
    @EnvironmentObject var pokemonStore: PokemonStore

    var body: some View {
        VStack {
            Text("Favourite Pokémon")
                .font(.largeTitle)
                .padding()

            if pokemonFavourites.favoriteIDs.isEmpty {
                Text("No favorite Pokémon yet!")
                    .font(.headline)
                    .padding(.top, 20)
            } else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    switch pokemonStore.pokemons {
                    case .success(let allPokemons):
                        let favoritePokemons = pokemonFavourites.favoriteIDs.compactMap { id in
                            allPokemons.first { $0.id == id }
                        }

                        if favoritePokemons.isEmpty {
                            Text("No favorite Pokémon available.")
                                .font(.headline)
                                .padding(.top, 20)
                        } else {
                            ForEach(favoritePokemons, id: \.id) { pokemon in
                                NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                                    PokemonCell(pokemon: pokemon)
                                }
                            }
                        }

                    case .failure:
                        Text("Failed to load Pokémon.")
                            .foregroundColor(.red)
                            .padding(.top, 20)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Favourites")
    }
}

#Preview {
    FavouritePokemonPage()
        .environmentObject(PokemonFavourites.shared)
        .environmentObject(PokemonStore())
}

