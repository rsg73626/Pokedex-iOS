//
//  RemotePokemonsService.swift
//  Pokedex
//
//  Created by Fulllab on 06/09/21.
//

import Foundation

class RemotePokemonsService: PokemonsService {
    
    var delegate: PokemonsServiceDelegate?
    
    func getPokemons() {
        let urlString: String = "https://ifpb.github.io/intin-topicos/desafios/pokedex/code/data/pokedex.json"
        
        guard let url = URL(string: urlString) else {
            delegate?.pokemonsService(didGetPokemons: [])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let pokemons = try? JSONDecoder().decode([Pokemon].self, from: data),
                  !pokemons.isEmpty else {
                self.delegate?.pokemonsService(didGetPokemons: [])
                return
            }
            self.delegate?.pokemonsService(didGetPokemons: pokemons)
        }.resume()
    }
    
}
