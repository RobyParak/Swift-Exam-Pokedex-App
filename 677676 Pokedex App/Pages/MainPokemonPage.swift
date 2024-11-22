//
//  MainPokemonPage.swift
//  677676 Pokedex App
//
//
import SwiftUI

struct MainPokemonPage: View {
    @EnvironmentObject var pokemonStore: PokemonStore
    @EnvironmentObject var pokemonFavourites : PokemonFavourites
    
    @StateObject var vm: PokemonViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    TextField("Search", text: $vm.search)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color.teal)
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    Text("Gen 1 Pokémons")
                        .font(.largeTitle)
                        .padding(.all, 14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    switch pokemonStore.pokemons {
                    case .success(let pokemons):
                        let filteredPokemons = pokemons.filter {
                            vm.search.isEmpty || $0.name.lowercased().contains(vm.search.lowercased())
                        }
                        
                        if filteredPokemons.isEmpty {
                            Text("No Pokémon found!")
                                .font(.headline)
                                .padding(.top, 20)
                        } else {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                                ForEach(filteredPokemons, id: \.self) { pokemon in
                                    NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                                        PokemonCell(pokemon: pokemon)
                                    }
                                }
                            }
                            .padding()
                        }
                        
                    case .failure:
                        Text("Failed to load Pokémon.")
                            .foregroundColor(.red)
                            .padding(.top, 20)
                    }
                }
            }
            .navigationTitle("Pokédex")
        }
    }
}

#Preview {
    MainPokemonPage(vm: .init())
        .environmentObject(PokemonStore())
        .environmentObject(PokemonFavourites.shared)
}
