//
//  PokemonsService.swift
//  Pokedex
//
//  Created by Fulllab on 06/09/21.
//

import Foundation

protocol PokemonsServiceDelegate {
    func pokemonsService(didGetPokemons pokemons: [Pokemon])
}

protocol PokemonsService {
    var delegate: PokemonsServiceDelegate? { get set }
    
    func getPokemons()
}
