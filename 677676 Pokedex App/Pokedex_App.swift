//
//  _677676_Pokedex_AppApp.swift
//  677676 Pokedex App
//
//
import SwiftUI

@main
struct Pokedex_App: App {
    @StateObject private var pokemonStore = PokemonStore()
    @StateObject private var pokemonFavourites = PokemonFavourites.shared
    
    var body: some Scene {
        WindowGroup {
            SplashScreenWrapperView()
                .environmentObject(pokemonStore)
                .environmentObject(pokemonFavourites)
        }
    }
}

struct SplashScreenWrapperView: View {
    @EnvironmentObject var pokemonStore: PokemonStore
    @EnvironmentObject var pokemonFavourites: PokemonFavourites
    @State private var showSplashScreen = true
    
    var body: some View {
        ZStack {
            if showSplashScreen {
                SplashScreenView()
            } else {
                TabbarView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showSplashScreen = false
                }
            }
        }
        .environmentObject(pokemonStore)
        .environmentObject(pokemonFavourites)
    }
}
