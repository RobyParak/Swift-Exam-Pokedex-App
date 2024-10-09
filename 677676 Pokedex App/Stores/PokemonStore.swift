//
//  PokemonService.swift
//  677676 Pokedex App
//
//  Created by admin on 10/7/24.
//

import Foundation
import Combine

class PokemonStore {
    static let shared = PokemonStore()
    
 
    
    private func extractId(from url: String) -> Int? {
        let components = url.split(separator: "/")
        return Int(components.last ?? "")
    }
}
