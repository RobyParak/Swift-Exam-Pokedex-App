//
//  SwiftUIView.swift
//  677676 Pokedex App
//
//
import SwiftUI

struct TabbarView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                MainPokemonPage(vm: MainPokemonPageViewModel(pokemonStore: PokemonStore()))
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.width < -100 {
                                    selectedTab = 1
                                }
                            }
                    )
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(0)
                
                FavouritePokemonPage()
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.width > 100 {
                                    selectedTab = 0
                                }
                            }
                    )
                    .tabItem {
                        Label("Favorites", systemImage: "heart")
                    }
                    .tag(1)
            }
        }
    }
}
