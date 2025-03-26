//
//  PokemonDetailView.swift
//  677676 Pokedex App
//
//  Created by admin on 10/7/24.
//
import SwiftUI

struct PokemonDetailView: View {
    let pokemon: PokemonModel
        @StateObject private var viewModel: PokemonViewModel
        
        init(pokemon: PokemonModel) {
            self.pokemon = pokemon
            _viewModel = StateObject(wrappedValue: PokemonViewModel(pokemon: pokemon))
        }
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            if viewModel.isLoading {
                loadingStateView
            } else if let errorMessage = viewModel.errorMessage {
                errorStateView(errorMessage: errorMessage)
            } else if let details = viewModel.selectedPokemon {
                contentView(details: details)
            } else {
                noDataStateView
            }
        }
        .onAppear {
            viewModel.fetchPokemonDetails(for: pokemon)
        }
        .navigationBarBackButtonHidden(false)
    }
    
    private var loadingStateView: some View {
        VStack {
            ProgressView("Loading Pokémon...")
                .progressViewStyle(CircularProgressViewStyle(tint: Color("AccentColor")))
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
                viewModel.fetchPokemonDetails(for: pokemon)
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
    
    private func contentView(details: PokemonModel) -> some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: details.imageUrl)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                } placeholder: {
                    ProgressView()
                }
                
                Text(details.name)
                    .font(.largeTitle)
                    .padding()
                
                Text("#\(String(format: "%03d", details.id))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                if !details.types.isEmpty {
                    Text("Types: \(details.types.joined(separator: ", "))")
                        .font(.headline)
                        .padding(.top, 8)
                }
                
                if !details.abilities.isEmpty {
                    Text("Abilities: \(details.abilities.joined(separator: ", "))")
                        .font(.headline)
                        .padding(.top, 8)
                }
                
                if let height = details.height {
                    Text("Height: \(height) m")
                        .padding(.top, 8)
                }
                
                if let weight = details.weight {
                    Text("Weight: \(weight) kg")
                        .padding(.top, 8)
                }
                
                if let baseExperience = details.baseExperience {
                    Text("Base Experience: \(baseExperience)")
                        .padding(.top, 8)
                }
            }
        }
    }
    
    private var noDataStateView: some View {
        VStack {
            Text("No Pokémon data available.")
                .font(.headline)
                .foregroundColor(.gray)
                .padding()
        }
    }
}
