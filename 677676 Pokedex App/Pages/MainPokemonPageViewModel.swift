//
//  MainPokemonPageView.swift
//  677676 Pokedex App
//
//  Created by admin on 10/7/24.
//

import SwiftUI
import Combine

extension MainPokemonPage {
    @MainActor
    final class PokemonViewModel: ObservableObject{
        
        @Published var search: String = ""
        private var cancellables: [AnyCancellable] = []
        
        func setup() async{
            
        }
    }
}
