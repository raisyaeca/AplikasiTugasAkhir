//
//  TabelBobotKecamatanTableViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 8/26/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit
import CoreData


class TabelBobotTableViewController: SwipeTableViewController {
    
    
    @IBOutlet weak var tambahBobotButton: UIBarButtonItem!
    
    var bobotParameterArray = [BobotParameters]()
    
    var userLoggedIn: Users?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        
        loadBobots()
        
        if userLoggedIn?.role == "Client" {
        
            tableView.allowsSelection = false
            navigationItem.rightBarButtonItem = nil
                  
        }


    }
    
    //MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bobotParameterArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if userLoggedIn?.role == "Client" {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        }
        
        let bobot = bobotParameterArray[indexPath.row]
        
        cell.textLabel?.text = bobot.namaParameter
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditBobot", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditBobot" {
            
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedBobot = bobotParameterArray[indexPath.row]
            let navController = segue.destination as! UINavigationController
            let destinationVC = navController.topViewController as! TambahEditbobotTableViewController
            destinationVC.titleNavigasi = "Ubah"
            destinationVC.selectedBobot = selectedBobot
            
            
        }
    }
    
    //MARK: Data Manipulation Methods
    
    func loadBobots(with request: NSFetchRequest<BobotParameters> = BobotParameters.fetchRequest()) {
        do {
            bobotParameterArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func saveBobot() {
        do {
           
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func deleteBanyakNilaiKlasifikasi(namaParameternya: String) {
        let request : NSFetchRequest<NilaiKlasifikasi> = NilaiKlasifikasi.fetchRequest()
        
        request.predicate = NSPredicate(format: "namaParameternya.namaParameter MATCHES %@", namaParameternya)
        
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
    
    func deleteBanyakDataAlternatif(namaParameternya: String) {
        let request : NSFetchRequest<DataAlternatifs> = DataAlternatifs.fetchRequest()
        
        request.predicate = NSPredicate(format: "namaParameternya.namaParameter MATCHES %@", namaParameternya)
        
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
        
        let alert = UIAlertController(title: "Hapus Bobot", message: "Yakin untuk menghapus?", preferredStyle: UIAlertController.Style.alert)
               
               alert.addAction(UIAlertAction(title: "Batal", style: UIAlertAction.Style.default, handler: { _ in
                   //batal hapus
               }))
               
               alert.addAction(UIAlertAction(title: "Hapus", style: UIAlertAction.Style.default, handler: { (_ : UIAlertAction!) in
                self.deleteBanyakDataAlternatif(namaParameternya: self.bobotParameterArray[indexPath.row].namaParameter!)
                self.deleteBanyakNilaiKlasifikasi(namaParameternya: self.bobotParameterArray[indexPath.row].namaParameter!)
                    self.context.delete(self.bobotParameterArray[indexPath.row])
                    self.bobotParameterArray.remove(at: indexPath.row) //menghapus melalui array sekarang
                self.saveBobot() //menghapus di persistent data
                           
               }))
               
                self.present(alert, animated: true, completion: nil)
        
    }
    

    @IBAction func unwindToBobotTable(segue: UIStoryboardSegue) {
        guard  segue.identifier == "saveUnwind" else { return }
        
        let sourceViewController = segue.source as! TambahEditbobotTableViewController
        
        if let selectedBobot = sourceViewController.selectedBobot {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                bobotParameterArray[selectedIndexPath.row] = selectedBobot
                
                
            }
        } else {
            
            let newBobot = BobotParameters(context: context)
            newBobot.namaParameter = sourceViewController.namaParameterTextField.text
            newBobot.nilaiBobotParameter =  sourceViewController.nilaiBobotTextField.text!.floatValue
            newBobot.createdAt = Date()
            newBobot.updatedAt = Date()
            newBobot.createdBy = userLoggedIn

            bobotParameterArray.append(newBobot)
        }
        
        saveBobot()
        loadBobots()
    }
}

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

//MARK: - Search Bar Methods

extension TabelBobotTableViewController: UISearchBarDelegate {
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
