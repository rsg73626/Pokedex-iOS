//
//  PokemonsView.swift
//  Pokedex
//
//  Created by Corebiz on 20/04/21.
//

import UIKit

class PokemonsView: UITableViewController, UISearchBarDelegate, PokemonsServiceDelegate {
    
    // MARK: - Properties
    
    let tipos = ["normal", "fire", "water", "grass", "bug", "poison", "electric", "ground",
                 "fighting", "psychic", "rock", "flying", "ghost", "ice", "dragon", "fairy"]
    
    var pokemonsOriginal = [Pokemon]()
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
        
        let searchBar = UISearchBar()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        service = RemotePokemonsService()
        service.delegate = self
        
        loadingView.isHidden = false
        service.getPokemons()
    }
    
    // MARK: - Actions
    
    @IBAction func didSelectFilter(_ sender: Any) {
        let alert = UIAlertController(title: "Filter",
                                      message: "Choose your pokemon's type",
                                      preferredStyle: .actionSheet)
        
        let todos = UIAlertAction(title: "all",
                                  style: .default,
                                  handler: { alert in
                                     self.pokemons=self.pokemonsOriginal
                                     self.tableView.reloadData()
                                  })
        alert.addAction(todos)
        
        tipos.forEach{tipo in
            let novoTipo = UIAlertAction(title: tipo,
                                     style: .default,
                                     handler: { alert in
                                        self.pokemons=self.pokemonsOriginal.filter({ pokemon in pokemon.type.contains(tipo)
                                        })
                                        self.tableView.reloadData()
                                     })
            alert.addAction(novoTipo)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didSelectSort(_ sender: Any) {
        let alert = UIAlertController(title: "Sort",
                                      message: "",
                                      preferredStyle: .actionSheet)
        
        let aZ = UIAlertAction(title: "a-z",
                                 style: .default,
                                 handler: { alert in
                                    self.pokemons=self.pokemons.sorted(by: {$0.name < $1.name})
                                    self.tableView.reloadData()
                                 })
        alert.addAction(aZ)
        
        let zA = UIAlertAction(title: "z-a",
                                 style: .default,
                                 handler: { alert in
                                    self.pokemons=self.pokemons.sorted(by: {$0.name > $1.name})
                                    self.tableView.reloadData()
                                 })
        alert.addAction(zA)
        
        let idAsc = UIAlertAction(title: "id (1-151)",
                                 style: .default,
                                 handler: { alert in
                                    self.pokemons=self.pokemons.sorted(by: {$0.id < $1.id})
                                    self.tableView.reloadData()
                                 })
        alert.addAction(idAsc)
        
        let idDesc = UIAlertAction(title: "id (151-1)",
                                 style: .default,
                                 handler: { alert in
                                    self.pokemons=self.pokemons.sorted(by: {$0.id > $1.id})
                                    self.tableView.reloadData()
                                 })
        alert.addAction(idDesc)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - PokemonsServiceDelegate functions
    
    func pokemonsService(didGetPokemons pokemons: [Pokemon]) {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
            self.pokemons = pokemons
            self.pokemonsOriginal = pokemons
            if pokemons.isEmpty {
                self.showErrorMessage()
            } else {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        pokemons.isEmpty ? .zero : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokemons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokeCell", for: indexPath)
      
        cell.textLabel?.text = pokemons[indexPath.row].name
        cell.detailTextLabel?.text = "testes"
        cell.imageView?.image = UIImage(named: pokemons[indexPath.row].name)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPokemon = pokemons[indexPath.row]
        performSegue(withIdentifier: "pokeStats", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let statsScreen = segue.destination as? StatsViewController,
              let selected = selectedPokemon else {
            return
        }
        
        statsScreen.pokemon = selected
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            pokemons = pokemonsOriginal
        }else{
            pokemons = pokemonsOriginal.filter {pokemon in pokemon.name.uppercased().contains(searchText.uppercased())}
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
