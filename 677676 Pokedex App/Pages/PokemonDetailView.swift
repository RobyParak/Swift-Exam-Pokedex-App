//
//  PokemonDetailView.swift
//  677676 Pokedex App
//
import SwiftUI

struct PokemonDetailView: View {
    let pokemon: PokemonModel
    @StateObject private var viewModel: PokemonViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(pokemon: PokemonModel) {
        self.pokemon = pokemon
        _viewModel = StateObject(wrappedValue: PokemonViewModel())
    }
    
    var body: some View {
        ZStack {
            Color(.white)
                .edgesIgnoringSafeArea(.all)
            
            if viewModel.isLoading {
                loadingStateView
            } else if let errorMessage = viewModel.errorMessage {
                errorStateView(errorMessage: errorMessage)
            } else if let details = viewModel.pokemonDetails {
                contentView(details: details)
            } else {
                noDataStateView
            }
        }
        .onAppear {
            viewModel.fetchDetails(for: pokemon.id)
        }
        .navigationBarBackButtonHidden(false)
    }
    
    private var loadingStateView: some View {
        VStack {
            ProgressView("Loading Pokémon...")
                .progressViewStyle(CircularProgressViewStyle(tint: Color(.systemBlue)))
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
                viewModel.fetchDetails(for: pokemon.id)
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
    
    private var noDataStateView: some View {
        VStack {
            Text("No Pokémon data available.")
                .font(.headline)
                .foregroundColor(.gray)
                .padding()
        }
    }
    
    private func contentView(details: PokemonModel) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header with image and favorite button
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: URL(string: details.imageUrl)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .overlay(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 1))
                    } placeholder: {
                        ProgressView()
                    }
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                            viewModel.toggleFavorite(pokemon: details)
                        }
                    }) {
                        Image(systemName: viewModel.isFavorite(pokemon: details) ? "heart.fill" : "heart")
                            .font(.system(size: 24))
                            .foregroundColor(viewModel.isFavorite(pokemon: details) ? .red : .gray)
                            .padding(12)
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }
                    .padding(8)
                }
                
                // Name and ID
                VStack(spacing: 4) {
                    Text(details.name.capitalized)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("#\(String(format: "%03d", details.id))")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                // Types
                if !details.types.isEmpty {
                    HStack(spacing: 8) {
                        ForEach(details.types, id: \.self) { type in
                            Text(type.capitalized)
                                .font(.system(size: 14, weight: .medium))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(typeColor(for: type)))
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Basic info cards
                HStack(spacing: 16) {
                    infoCard(title: "Height", value: "\(details.height ?? 0) m", icon: "arrow.up.and.down")
                    infoCard(title: "Weight", value: "\(details.weight ?? 0) kg", icon: "scalemass")
                }
                .padding(.horizontal)
                
                // Abilities
                if !details.abilities.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Abilities")
                            .font(.headline)
                        
                        HStack(spacing: 8) {
                            ForEach(details.abilities, id: \.self) { ability in
                                Text(ability.capitalized)
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
    
    // Helper functions for the content view
    private func infoCard(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.blue)
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.gray)
            Text(value)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func typeColor(for type: String) -> Color {
        switch type.lowercased() {
        case "fire": return .orange
        case "water": return .blue
        case "grass": return .green
        case "electric": return .yellow
        case "psychic": return .purple
        case "ice": return .cyan
        case "dragon": return .indigo
        case "dark": return .black
        case "fairy": return .pink
        case "fighting": return .red
        case "flying": return .mint
        case "poison": return .purple
        case "ground": return .brown
        case "rock": return .gray
        case "bug": return .green
        case "ghost": return .indigo
        case "steel": return .gray
        case "normal": return .gray
        default: return .gray
        }
    }
}
