//
//  MainPokemonPage.swift
//  677676 Pokedex App
//
//
import SwiftUI

struct MainPokemonPage: View {
    @EnvironmentObject var pokemonFavourites: PokemonFavourites
    @StateObject var vm: MainPokemonPageViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        if vm.search.isEmpty {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.leading, 18)
                        } else {
                            Button(action: {
                                vm.search = "" // Clear search text when clicked
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                            .padding(.leading, 18)
                        }

                        TextField("Gen 1 Pokémon only", text: $vm.search)
                            .padding(.trailing, 12)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.top)

                    // Handle different states (Loading, Error, Success)
                    if vm.isLoading {
                        loadingStateView
                    } else {
                        switch vm.pokemons {
                        case .success(_):
                            if vm.filteredPokemons.isEmpty {
                                Text("No Pokémon found!")
                                    .font(.headline)
                                    .padding(.top, 20)
                            } else {
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                                    ForEach(vm.filteredPokemons, id: \.self) { pokemon in
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
            .refreshable {
                await vm.refreshData()
            }
            .navigationTitle("Kanto Pokémon")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var loadingStateView: some View {
        VStack {
            ProgressView("Loading Pokémon...")
                .progressViewStyle(CircularProgressViewStyle(tint: Color(.blue)))
                .scaleEffect(1.5)
            Spacer().frame(height: 20)
            Text("Please wait while we fetch details.")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(.gray)
        }
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
            Button(action: {
                Task {
                    await vm.refreshData()
                }
            }) {
                Text("Retry")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
}
