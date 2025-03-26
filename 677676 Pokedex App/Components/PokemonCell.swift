//
//  PokemonCell.swift
//  677676 Pokedex App
//
//  Created by admin on 10/7/24.
//

import SwiftUI

struct PokemonCell: View {
    @EnvironmentObject var pokemonStore: PokemonStore
    let pokemon: PokemonModel

    var body: some View {
        VStack {
            Text("#\(String(format: "%03d", pokemon.id))")
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(8)
                .background(Color.teal)
                .cornerRadius(5)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Pokémon image
            AsyncImage(url: URL(string: pokemon.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 125, height: 100)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            } placeholder: {
                ProgressView()
                    .frame(width: 125, height: 100) // Same size as image
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }

            // Pokémon name
            Text(pokemon.name.capitalized) // Capitalize the name
                .font(.headline)
                .foregroundColor(.black)
                .padding(.top, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.all, 12)
        .background(Color(red: 0.9647, green: 0.9647, blue: 1.0))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}
