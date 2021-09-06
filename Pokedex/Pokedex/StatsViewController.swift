//
//  StatsViewController.swift
//  Pokedex
//
//  Created by Corebiz on 26/04/21.
//

import UIKit

class StatsViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var hp: UILabel!
    @IBOutlet weak var atk: UILabel!
    @IBOutlet weak var def: UILabel!
    @IBOutlet weak var spAtk: UILabel!
    @IBOutlet weak var spDef: UILabel!
    @IBOutlet weak var speed: UILabel!
    
    var pokemon : Pokemon?
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
