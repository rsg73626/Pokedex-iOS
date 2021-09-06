//
//  Pokemon.swift
//  Pokedex
//
//  Created by Renan Germano on 06/09/21.
//

import Foundation

struct Pokemon: Codable {
    
    let id: Int
    let name: String
    let price: Float?
    let type: [String]
    let stats: Stats
    
}
