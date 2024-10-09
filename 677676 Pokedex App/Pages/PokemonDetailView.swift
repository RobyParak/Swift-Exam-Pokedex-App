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

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: pokemon.imageUrl)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            } placeholder: {
                ProgressView()
            }

            Text(pokemon.name)
                .font(.largeTitle)
                .padding()

            Text("Type: \(pokemon.type)")
                .font(.title2)
                .foregroundColor(.gray)
                .padding(.bottom)

            Spacer()
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
                }, label: {
                    Image(systemName: favourites.isFavorite(pokemon.id) ? "heart.fill" : "heart")
                        .foregroundColor(favourites.isFavorite(pokemon.id) ? .blue : .gray)
                })
            }
        }
    }
}

#Preview {
    NavigationView {
        PokemonDetailView(pokemon: PokemonModel(id: 1, name: "Bulbasaur", type: "Grass"))
            .environmentObject(PokemonFavourites.shared)
    }
}
