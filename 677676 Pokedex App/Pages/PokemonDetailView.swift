//
//  PokemonDetailView.swift
//  677676 Pokedex App
//
//  Created by admin on 10/7/24.
//
import SwiftUI

struct PokemonDetailView: View {
    let pokemon: PokemonModel
    @EnvironmentObject var favourites: PokemonFavourites
    @ObservedObject private var viewModel = PokemonViewModel()

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading Pokémon details...")
            } else if let detailedPokemon = viewModel.selectedPokemon {
                ScrollView {
                    VStack {
                        AsyncImage(url: URL(string: detailedPokemon.imageUrl)) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        Text(detailedPokemon.name)
                            .font(.largeTitle)
                            .padding()
                        
                        Text("#\(String(format: "%03d", detailedPokemon.id))")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        if !detailedPokemon.types.isEmpty {
                            Text("Types: \(detailedPokemon.types.joined(separator: ", "))")
                                .font(.headline)
                                .padding(.top, 8)
                        }

                        if !detailedPokemon.abilities.isEmpty {
                            Text("Abilities: \(detailedPokemon.abilities.joined(separator: ", "))")
                                .font(.headline)
                                .padding(.top, 8)
                        }

                        if let height = detailedPokemon.height {
                            Text("Height: \(height) m")
                                .padding(.top, 8)
                        }

                        if let weight = detailedPokemon.weight {
                            Text("Weight: \(weight) kg")
                                .padding(.top, 8)
                        }

                        if let baseExperience = detailedPokemon.baseExperience {
                            Text("Base Experience: \(baseExperience)")
                                .padding(.top, 8)
                        }
                    }
                }
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            viewModel.fetchPokemonDetails(for: pokemon)
        }
        .navigationTitle(pokemon.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if favourites.isFavorite(pokemon.id) {
                        favourites.remove(pokemon.id)
                    } else {
                        favourites.add(pokemon.id)
                    }
                }) {
                    Image(systemName: favourites.isFavorite(pokemon.id) ? "heart.fill" : "heart")
                        .foregroundColor(favourites.isFavorite(pokemon.id) ? .blue : .gray)
                }
            }
        }
    }
}


#Preview {
    NavigationView {
        PokemonDetailView(pokemon: PokemonModel(id: 1, name: "Bulbasaur"))
            .environmentObject(PokemonFavourites.shared)
    }
}
