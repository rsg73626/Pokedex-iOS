//
//  Stats.swift
//  Pokedex
//
//  Created by Fulllab on 06/09/21.
//

import Foundation

struct Stats: Codable{
    
    let total: Int
    let hp: Int
    let attack: Int
    let defense: Int
    let spAtk: Int
    let spDef: Int
    let speed: Int
    
    enum CodingKeys: String, CodingKey{
        case total
        case hp
        case attack
        case defense
        case spAtk = "sp-atk"
        case spDef = "sp-def"
        case speed
    }
    
}
