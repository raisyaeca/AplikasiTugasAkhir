//
//  KumpulanBobotKeKlasifikasiTableViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 9/13/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit
import CoreData

class KumpulanBobotKeKlasifikasiTableViewController: UITableViewController {
    
    var userLoggedIn: Users?
    var bobotArray = [BobotParameters]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        loadBobots()
        navigationController?.applyDesign()
        
        
        
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bobotArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = bobotArray[indexPath.row].namaParameter
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToNilaiKlasifikasi", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TabelNilaiKlasifikasiTableViewController
        destinationVC.userLoggedIn = userLoggedIn
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedBobot = bobotArray[indexPath.row]
            
        }
    }
    // MARK: - Data Manipulation Methods
    
    func loadBobots(with request: NSFetchRequest<BobotParameters> = BobotParameters.fetchRequest()) {
        do {
            bobotArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
}

//MARK: - Search Bar Methods

extension KumpulanBobotKeKlasifikasiTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<BobotParameters> = BobotParameters.fetchRequest()
        
        request.predicate = NSPredicate(format: "namaParameter CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "namaParameter", ascending: true)]
        
        loadBobots(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadBobots()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
