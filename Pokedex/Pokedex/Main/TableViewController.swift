//
//  TableViewController.swift
//  Pokedex
//
//  Created by Corebiz on 20/04/21.
//

import UIKit

class TableViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Properties
    
    let tipos : [String] = ["normal",
                            "fire", 
                            "water", 
                            "grass",
                            "bug",
                            "poison", 
                            "electric", 
                            "ground", 
                            "fighting", 
                            "psychic", 
                            "rock", 
                            "flying", 
                            "ghost", 
                            "ice", 
                            "dragon", 
                            "fairy"]
    
    var pokemonsOriginal: [Pokemon] = []
    var pokemons: [Pokemon] = []
    var selectedPokemon: Pokemon?
    
    // MARK: - Life cycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBar = UISearchBar()
        
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        
        let url = "https://ifpb.github.io/intin-topicos/desafios/pokedex/code/data/pokedex.json"
        getData(from: url)
 
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pokemons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokeCell", for: indexPath)
      
        cell.textLabel?.text = pokemons[indexPath.row].name
        cell.detailTextLabel?.text = "testes"
        cell.imageView?.image = UIImage(named: pokemons[indexPath.row].name)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPokemon = pokemons[indexPath.row]
        performSegue(withIdentifier: "pokeStats", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        /*segue.identifier
        segue.destination*/
        guard let statsScreen = segue.destination as? StatsViewController, let selected = selectedPokemon else{
            return
        }
        
        statsScreen.pokemon = selected
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty{
            pokemons=pokemonsOriginal
        }else{
            pokemons=pokemonsOriginal.filter({pokemon in pokemon.name.uppercased().contains(searchText.uppercased())})
        }
            
        tableView.reloadData()
        
    }
    
    // MARK: - Aux functions
    
    private func getData(from url: String){
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            
            guard let data = data, error == nil else{
                print("failedd to get data")
                return
            }
            
            var json: [Pokemon]?
            do{
                json = try JSONDecoder().decode([Pokemon].self, from: data)
            }catch{
                print("Failedd \(error.localizedDescription)")
            }
            
            guard let dados = json else{
                return
            }
            
            self.pokemonsOriginal=dados
            self.pokemons=dados
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        })
        
        task.resume()
        
    }
    
}
