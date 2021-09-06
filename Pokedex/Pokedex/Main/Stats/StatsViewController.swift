//
//  StatsView.swift
//  Pokedex
//
//  Created by StatsView on 26/04/21.
//

import UIKit

protocol StatsViewDelegate {
    func statsView(didUpdatePokemon pokemon: Pokemon, favorite: Bool)
}

class StatsView: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var hp: UILabel!
    @IBOutlet weak var atk: UILabel!
    @IBOutlet weak var def: UILabel!
    @IBOutlet weak var spAtk: UILabel!
    @IBOutlet weak var spDef: UILabel!
    @IBOutlet weak var speed: UILabel!
    
    // MARK: - Properties
    
    var pokemon: Pokemon?
    var isFavorite = false
    var delegate: StatsViewDelegate?
    
    
    // MARK: - Life cycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.image = UIImage(named: pokemon?.name ?? "")
        name.text = pokemon?.name
        type.text = "Type: \(pokemon?.type.first ?? "")"
        updateFavoriteButton()
        total.text = "Total: \(pokemon?.stats.total ?? 0)"
        hp.text = "Hp: \(pokemon?.stats.hp ?? 0)"
        atk.text = "Atk: \(pokemon?.stats.attack ?? 0)"
        def.text = "Def: \(pokemon?.stats.defense ?? 0)"
        spAtk.text = "Sp-atk: \(pokemon?.stats.spAtk ?? 0)"
        spDef.text = "Sp-def: \(pokemon?.stats.spDef ?? 0)"
        speed.text = "Speed: \(pokemon?.stats.speed ?? 0)"
    }
    
    // MARK: - Actions
    
    @IBAction func didTapFavoriteButton() {
        isFavorite = !isFavorite
        updateFavoriteButton()
        if let pokemon = pokemon {
            delegate?.statsView(didUpdatePokemon: pokemon, favorite: isFavorite)
        }
    }
    
    // MARK: - Aux functions
    
    private func updateFavoriteButton() {
        favoriteButton.setTitle(isFavorite ? "❤️" : "👎", for: .normal)
    }
    

}
