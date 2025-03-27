//
//  PokemonDetailView.swift
//  677676 Pokedex App
//
import SwiftUI

struct PokemonDetailView: View {
    let pokemon: PokemonModel
    @StateObject var viewModel: PokemonViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            Group {
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
        }
        .task {
            await viewModel.fetchDetails(for: pokemon.id)
        }
        .navigationBarBackButtonHidden(false)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func contentView(details: PokemonModel) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                pokemonImageSection(details: details)
                nameAndIdSection(details: details)
                typesSection(details: details)
                aboutSection(details: details)
            }
        }
    }
    
    private func pokemonImageSection(details: PokemonModel) -> some View {
        ZStack(alignment: .topTrailing) {
            AsyncImage(url: URL(string: details.imageUrl)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .overlay(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 1))
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .foregroundColor(.gray)
                default:
                    ProgressView()
                }
            }
            
            favoriteButton(details: details)
                .padding(8)
        }
    }
    
    private func favoriteButton(details: PokemonModel) -> some View {
        Button {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                viewModel.toggleFavorite(pokemon: details)
            }
        } label: {
            Image(systemName: viewModel.isFavorite(pokemon: details) ? "heart.fill" : "heart")
                .font(.system(size: 24))
                .foregroundColor(viewModel.isFavorite(pokemon: details) ? .red : .gray)
                .padding(12)
                .background(Color.white.opacity(0.8))
                .clipShape(Circle())
                .shadow(radius: 3)
        }
    }
    
    private func nameAndIdSection(details: PokemonModel) -> some View {
        VStack(spacing: 4) {
            Text(details.name.capitalized)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.primary)
            
            Text("#\(String(format: "%03d", details.id))")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
        }
        .padding()
    }
    
    private func typesSection(details: PokemonModel) -> some View {
        Group {
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
        }
    }
    
    private func aboutSection(details: PokemonModel) -> some View {
        VStack(spacing: 16) {
            Text("About")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                InfoRow(title: "Name", value: details.name.capitalized)
                InfoRow(title: "ID", value: "#\(String(format: "%03d", details.id))")
                InfoRow(title: "Base XP", value: "\(details.baseExperience ?? 0)")
                InfoRow(title: "Weight", value: "\(formatWeight(details.weight)) kg")
                InfoRow(title: "Height", value: "\(formatHeight(details.height)) m")
                InfoRow(title: "Types", value: details.types.map { $0.capitalized }.joined(separator: ", "))
                InfoRow(title: "Abilities", value: details.abilities.map { $0.capitalized }.joined(separator: ", "))
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
    
    struct InfoRow: View {
        let title: String
        let value: String
        
        var body: some View {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(width: 100, alignment: .leading)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
            }
        }
    }
    
    private func formatWeight(_ weight: Double?) -> String {
        guard let weight = weight else { return "0.0" }
        return String(format: "%.1f", weight / 10)
    }

    private func formatHeight(_ height: Double?) -> String {
        guard let height = height else { return "0.0" }
        return String(format: "%.1f", height / 10)
    }
    
    private var loadingStateView: some View {
        VStack {
            ProgressView("Loading Pokémon...")
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(1.5)
            
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
            
            Button {
                Task {
                    await viewModel.fetchDetails(for: pokemon.id)
                }
            } label: {
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
        Text("No Pokémon data available.")
            .font(.headline)
            .foregroundColor(.gray)
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
