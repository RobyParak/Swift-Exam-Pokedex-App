//
//  _77676_Pokedex_AppApp.swift
//  677676 Pokedex App
//
//  Created by admin on 10/7/24.
//

import SwiftUI

@main
struct Pokedex_App: App {
    var body: some Scene {
        WindowGroup {
            MainPokemonPage(vm: .init())
        }
    }
}
