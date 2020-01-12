//
//  KecKeAlterKaliParamTableViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 9/13/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit
import CoreData

//MARK: - Protocol


class KecKeAlterKaliParamTableViewController: UITableViewController {
    
    var kecamatanArray = [Kecamatans]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedButton: String?
    var selectedKabupaten: Kabupaten? {
        didSet {
            loadKecamatan()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        navigationController?.applyDesign()

        switch selectedButton {
        case "AlterKaliParam":
            navigationItem.title = "Alternatif x Parameter"
        case "FaktorEvaluasi":
            navigationItem.title = "Faktor Evaluasi"
        case "BobotEvaluasi":
            navigationItem.title = "Bobot Evaluasi per Alternatif"
        default:
            break
        }

    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kecamatanArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "KecamatanCell", for: indexPath)
        
        cell.textLabel?.text = kecamatanArray[indexPath.row].namaDaerah
        
        return cell
        
    }
    
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "goToAlterKaliParam", sender: self)
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! AlterKaliParamTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedKecamatan = kecamatanArray[indexPath.row]
            destinationVC.selectedButton = selectedButton
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
    
    
    

}

    
