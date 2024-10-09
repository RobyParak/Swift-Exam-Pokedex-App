//
//  SwiftUIView.swift
//  677676 Pokedex App
//
//  Created by admin on 10/7/24.
//

import SwiftUI

struct TabbarView: View {
    var body: some View {
        TabView {
            MainPokemonPage(vm: .init())
                .tabItem {
                    Label( "Home", systemImage: "house")
                }
            FavouritePokemonPage()
                .tabItem {
                    Label("Favourites", systemImage: "heart")                }
        }
    }
}
#Preview {
    TabbarView()
}
