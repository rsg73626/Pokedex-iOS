//
//  PokemonsView.swift
//  Pokedex
//
//  Created by Corebiz on 20/04/21.
//

import UIKit

class PokemonsView: UITableViewController, PokemonsServiceDelegate, StatsViewDelegate {
    
    // MARK: - Properties
    
    var favoritePokemonIds = [Int]()
    var pokemons = [Pokemon]()
    var selectedPokemon: Pokemon?
    
    var service: PokemonsService!
    
    // MARK: - Helper variables
    
    private lazy var loadingView: UIView = {
        let view = UIView()
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Getting Pokemons..."
        label.textAlignment = .center
        
        let loading = UIActivityIndicatorView()
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.startAnimating()
        
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        view.addSubview(loading)
        loading.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16).isActive = true
        loading.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        tableView.backgroundView = view
        
        return view
    }()
    
    // MARK: - Life cycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service = RemotePokemonsService()
        service.delegate = self
        
        loadingView.isHidden = false
        service.getPokemons()
    }
    
    // MARK: - Table view data source and delegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        pokemons.isEmpty ? .zero : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokemons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokeCell", for: indexPath)
        let pokemon = pokemons[indexPath.row]
      
        cell.selectionStyle = .none
        var content = cell.defaultContentConfiguration()
        content.image = UIImage(named: pokemon.name)
        content.text = pokemon.name
        content.secondaryText = "Favorite: " + (favoritePokemonIds.contains(pokemon.id) ? "❤️" : "👎")
        cell.contentConfiguration = content
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPokemon = pokemons[indexPath.row]
        performSegue(withIdentifier: "pokeStats", sender: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let statsScreen = segue.destination as? StatsView,
              let selected = selectedPokemon else {
            return
        }
        
        statsScreen.pokemon = selected
        statsScreen.isFavorite = favoritePokemonIds.contains(selected.id)
        statsScreen.delegate = self
    }
    
    // MARK: - PokemonsServiceDelegate functions
    
    func pokemonsService(didGetPokemons pokemons: [Pokemon]) {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
            self.pokemons = pokemons
            if pokemons.isEmpty {
                self.showErrorMessage()
            } else {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - StatsViewDelegate functions
    
    func statsView(didUpdatePokemon pokemon: Pokemon, favorite: Bool) {
        if favorite {
            favoritePokemonIds.append(pokemon.id)
        } else {
            favoritePokemonIds = favoritePokemonIds.filter { $0 != pokemon.id }
        }
        tableView.reloadData()
    }
    
    // MARK: - Aux functions
    
    private func showErrorMessage() {
        let alert = UIAlertController(title: "Error", message: "Error while trying to get pokemons. Please, try again later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
