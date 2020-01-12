//
//  KecamatanKeDataAlternatifsTableViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 9/13/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit
import CoreData

class KecamatanKeDataAlternatifsTableViewController: UITableViewController {
    
    var userLoggedIn: Users?
    var kecamatanArray = [Kecamatans]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedKabupaten: Kabupaten? {
           didSet {
               loadKecamatan()
           }
       }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        navigationController?.applyDesign()
        
  

    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kecamatanArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = kecamatanArray[indexPath.row].namaDaerah
        
        return cell
        
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDataAlternatif", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DataAlternatifTableViewController
        destinationVC.userLoggedIn = userLoggedIn
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedKecamatan = kecamatanArray[indexPath.row]
            
        }
    }
    // MARK: - Data Manipulation Methods
    
    func loadKecamatan(with request: NSFetchRequest<Kecamatans> = Kecamatans.fetchRequest()) {
        
        let predicate = NSPredicate(format: "dariKabupaten.namaKabupaten MATCHES %@", selectedKabupaten!.namaKabupaten!)
               
        request.predicate = predicate
        
        do {
            kecamatanArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadKecamatanSearch(with request: NSFetchRequest<Kecamatans> = Kecamatans.fetchRequest()) {
       
        do {
            kecamatanArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    
}

//MARK: - Search Bar Methods

extension KecamatanKeDataAlternatifsTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Kecamatans> = Kecamatans.fetchRequest()
        
        request.predicate = NSPredicate(format: "namaDaerah CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "namaDaerah", ascending: true)]
        
        loadKecamatanSearch(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadKecamatan()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

