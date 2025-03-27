//
//  SwiftUIView.swift
//  677676 Pokedex App
//
//
import SwiftUI

struct TabbarView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                MainPokemonPage(vm: MainPokemonPageViewModel(pokemonStore: PokemonStore()))
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(0)
            
            NavigationView {
                FavouritePokemonPage()
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Favorites", systemImage: "heart")
            }
            .tag(1)
        }
    }
}
