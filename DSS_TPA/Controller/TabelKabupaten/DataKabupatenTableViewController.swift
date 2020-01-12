//
//  DataKabupatenTableViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 11/4/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit
import CoreData

class DataKabupatenTableViewController: SwipeTableViewController {

    @IBOutlet weak var tambahKabupatenButton: UIBarButtonItem!
    
    var kabupatenArray = [Kabupaten]()
    var userLoggedIn: Users?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(userLoggedIn)
        
        tableView.rowHeight = 80.0
        loadKabupaten()
        
        if userLoggedIn?.role == "Client" {
        
            tableView.allowsSelection = false
            navigationItem.rightBarButtonItem = nil
                  
        }
    }
    
    //MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kabupatenArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if userLoggedIn?.role == "Client" {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        }
        
        cell.isEditing = false
        
     
        let kabupaten = kabupatenArray[indexPath.row]
        
        cell.textLabel?.text = kabupaten.namaKabupaten
       
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "EditKabupaten", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditKabupaten" {
            
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedKabupaten = kabupatenArray[indexPath.row]
            let navController = segue.destination as! UINavigationController
            let destinationVC = navController.topViewController as! UbahTambahKabTableViewController
            destinationVC.titleNavigasi = "Ubah"
            destinationVC.selectedKabupaten = selectedKabupaten
            
        }
    }
    
    //MARK: Data Manipulation Methods
       
       func loadKabupaten(with request: NSFetchRequest<Kabupaten> = Kabupaten.fetchRequest()) {
           do {
               kabupatenArray = try context.fetch(request)
           } catch {
               print("Error fetching data from context \(error)")
           }
           
           tableView.reloadData()
       }
       
       func saveKabupaten() {
           do {
               try context.save()
           } catch {
               print("Error saving context \(error)")
           }
           
           tableView.reloadData()
       }
       
       func deleteBanyakDataAlternatif(namaKabupaten: String) {
           let request : NSFetchRequest<DataAlternatifs> = DataAlternatifs.fetchRequest()
           
           request.predicate = NSPredicate(format: "namaKecamatannya.dariKabupaten.namaKabupaten MATCHES %@", namaKabupaten)
           
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
    
    func deleteKecamatan(namaKabupaten: String) {
        
        let request : NSFetchRequest<Kecamatans> = Kecamatans.fetchRequest()
        
        request.predicate = NSPredicate(format: "dariKabupaten.namaKabupaten MATCHES %@", namaKabupaten)
        
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
        
        let alert = UIAlertController(title: "Hapus Kabupaten", message: "Yakin untuk menghapus?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Batal", style: UIAlertAction.Style.default, handler: { _ in
            //batal hapus
        }))
        
        alert.addAction(UIAlertAction(title: "Hapus", style: UIAlertAction.Style.default, handler: { (_ : UIAlertAction!) in
            
            self.deleteBanyakDataAlternatif(namaKabupaten:
                self.kabupatenArray[indexPath.row].namaKabupaten!)
                   self.deleteKecamatan(namaKabupaten: self.kabupatenArray[indexPath.row].namaKabupaten!)
                  
                      self.context.delete(self.kabupatenArray[indexPath.row])
                      self.kabupatenArray.remove(at: indexPath.row) //menghapus melalui array sekarang
            self.saveKabupaten() //menghapus di persistent data
                        
                  }))
                  
        self.present(alert, animated: true, completion: nil)
        
       
       }
       
    

 
    
    @IBAction func unwindToKabupatenTable(segue: UIStoryboardSegue) {
        guard  segue.identifier == "saveUnwind" else { return }
        
        let sourceViewController = segue.source as! UbahTambahKabTableViewController
        
        if let selectedKabupaten = sourceViewController.selectedKabupaten {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                kabupatenArray[selectedIndexPath.row] = selectedKabupaten
                
            }
        } else {
            
            let newKabupaten = Kabupaten(context: context)
            newKabupaten.createdAt = Date()
            newKabupaten.updatedAt = Date()
            newKabupaten.createdBy = userLoggedIn
            newKabupaten.namaKabupaten = sourceViewController.kabupatenTextField.text
            
            kabupatenArray.append(newKabupaten)
           
        }
        
        saveKabupaten()
        loadKabupaten()
    }

   
}
