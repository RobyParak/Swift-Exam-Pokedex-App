//
//  _77676_Pokedex_AppApp.swift
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
            TabbarView()
                .environmentObject(pokemonStore)
                .environmentObject(pokemonFavourites)
        }
    }
}

