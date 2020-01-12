//
//  KabDatAlterTableViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 11/4/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit
import CoreData

class KabDatAlterTableViewController: UITableViewController {
    
    var userLoggedIn: Users?
    var kabupatenArray = [Kabupaten]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
         tableView.rowHeight = 80.0
         loadKabupaten()
        navigationController?.applyDesign()

    }
    
    // MARK: - Table view data source
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return kabupatenArray.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            cell.textLabel?.text = kabupatenArray[indexPath.row].namaKabupaten
            
            return cell
            
        }
        
        // MARK: - TableView Delegate Methods
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "goToKecamatan", sender: self)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destinationVC = segue.destination as! KecamatanKeDataAlternatifsTableViewController
            destinationVC.userLoggedIn = userLoggedIn
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedKabupaten = kabupatenArray[indexPath.row]
                
            }
        }
        // MARK: - Data Manipulation Methods
        
        func loadKabupaten(with request: NSFetchRequest<Kabupaten> = Kabupaten.fetchRequest()) {
            do {
                kabupatenArray = try context.fetch(request)
            } catch {
                print("Error fetching data from context \(error)")
            }
            
            tableView.reloadData()
        }
        
   
}
