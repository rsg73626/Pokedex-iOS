//
//  StatsViewController.swift
//  Pokedex
//
//  Created by Corebiz on 26/04/21.
//

import UIKit

class StatsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var hp: UILabel!
    @IBOutlet weak var atk: UILabel!
    @IBOutlet weak var def: UILabel!
    @IBOutlet weak var spAtk: UILabel!
    @IBOutlet weak var spDef: UILabel!
    @IBOutlet weak var speed: UILabel!
    
    // MARK: - Properties
    
    var pokemon : Pokemon?
    
    // MARK: - Life cycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.image = UIImage(named: pokemon?.name ?? "")
        type.text = "Type: \(pokemon?.type ?? [""])"
        total.text = "Total: \(pokemon?.stats.total ?? 0)"
        hp.text = "Hp: \(pokemon?.stats.hp ?? 0)"
        atk.text = "Atk: \(pokemon?.stats.attack ?? 0)"
        def.text = "Def: \(pokemon?.stats.defense ?? 0)"
        spAtk.text = "Sp-atk: \(pokemon?.stats.spAtk ?? 0)"
        spDef.text = "Sp-def: \(pokemon?.stats.spDef ?? 0)"
        speed.text = "Speed: \(pokemon?.stats.speed ?? 0)"
    }

}
