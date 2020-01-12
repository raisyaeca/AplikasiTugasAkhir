//
//  KecamatanDataTableViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 9/6/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit
import CoreData

class KecamatanDataTableViewController: SwipeTableViewController {

    @IBOutlet weak var tambahKecamatanButton: UIBarButtonItem!
    
    var kecamatanArray = [Kecamatans]()
    var userLoggedIn: Users?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedKabupaten: Kabupaten? {
        didSet {
            loadKecamatans()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        
        if userLoggedIn?.role == "Client" {
        
            tableView.allowsSelection = false
            navigationItem.rightBarButtonItem = nil
                  
        }
        
        
    }
    
    //MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kecamatanArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if userLoggedIn?.role == "Client" {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        }
        
        cell.isEditing = false
        
     
        let kecamatan = kecamatanArray[indexPath.row]
        
        cell.textLabel?.text = kecamatan.namaDaerah
       
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "EditKecamatan", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditKecamatan" {
            
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedKecamatan = kecamatanArray[indexPath.row]
            let navController = segue.destination as! UINavigationController
            let destinationVC = navController.topViewController as! TambahEditKecamatanTableViewController
            destinationVC.titleNavigasi = "Ubah"
            destinationVC.selectedKecamatan = selectedKecamatan
            
        }
    }
    
    //MARK: Data Manipulation Methods
    
    func loadKecamatans(with request: NSFetchRequest<Kecamatans> = Kecamatans.fetchRequest()) {
        
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
    
    func saveKecamatan() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func deleteBanyakDataAlternatif(namaKecamatan: String) {
        let request : NSFetchRequest<DataAlternatifs> = DataAlternatifs.fetchRequest()
        
        request.predicate = NSPredicate(format: "namaKecamatannya.namaDaerah MATCHES %@", namaKecamatan)
        
        do {
            let objects = try context.fetch(request)
            for object in objects {
                context.delete(object)
            }
            try context.save()
        } catch {
            print("Error deleting objects \(error)")
        }
        
    }
    
    
    //MARK: -Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Hapus Kecamatan", message: "Yakin untuk menghapus?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Batal", style: UIAlertAction.Style.default, handler: { _ in
            //batal hapus
        }))
        
        alert.addAction(UIAlertAction(title: "Hapus", style: UIAlertAction.Style.default, handler: { (_ : UIAlertAction!) in
                    
                    self.deleteBanyakDataAlternatif(namaKecamatan: self.kecamatanArray[indexPath.row].namaDaerah!)
                    self.context.delete(self.kecamatanArray[indexPath.row])
                    self.kecamatanArray.remove(at: indexPath.row) //menghapus melalui array sekarang
            self.saveKecamatan() //menghapus di persistent data
        }))
        
         self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func unwindToKecamatanTable(segue: UIStoryboardSegue) {
        guard  segue.identifier == "saveUnwind" else { return }
        
        let sourceViewController = segue.source as! TambahEditKecamatanTableViewController
        
        if let selectedKecamatan = sourceViewController.selectedKecamatan {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                kecamatanArray[selectedIndexPath.row] = selectedKecamatan
                
            }
        } else {
            
            let newKecamatan = Kecamatans(context: context)
            newKecamatan.createdAt = Date()
            newKecamatan.updatedAt = Date()
            newKecamatan.createdBy = userLoggedIn
            newKecamatan.namaDaerah = sourceViewController.kecamatanTextField.text
            newKecamatan.dariKabupaten = selectedKabupaten
            
            kecamatanArray.append(newKecamatan)
           
        }
        
        saveKecamatan()
        loadKecamatans()
    }
}

//MARK: - Search Bar Methods

extension KecamatanDataTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Kecamatans> = Kecamatans.fetchRequest()
        
        request.predicate = NSPredicate(format: "namaDaerah CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "namaDaerah", ascending: true)]
        
        loadKecamatanSearch(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadKecamatans()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
