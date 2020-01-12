//
//  DataAlternatifTableViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 8/26/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit
import CoreData

class DataAlternatifTableViewController: SwipeTableViewController {
    
    var userLoggedIn: Users?
    var dataAlternatifArray = [DataAlternatifs]()
    var selectedKecamatan: Kecamatans? {
        didSet {
            loadDataAlternatifs()
        }
    }
    
    
    @IBOutlet weak var tambahButton: UIBarButtonItem!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Data Alternatif \(selectedKecamatan?.namaDaerah ?? "")"
        
        if userLoggedIn?.role == "Client" {
            
            tableView.allowsSelection = false
            navigationItem.rightBarButtonItem = nil
                  
        }

    }
    
    //MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataAlternatifArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if userLoggedIn?.role == "Client" {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        }
        
        let nilaiAlternatif = dataAlternatifArray[indexPath.row]
       
        cell.textLabel?.text = nilaiAlternatif.namaParameternya?.namaParameter
        cell.detailTextLabel?.text = "\(String(describing: nilaiAlternatif.rangeNilainya!.rangeNilaiParameter!)) : \(NSString(format: "%.2f", nilaiAlternatif.rangeNilainya?.nilai_klasifikasi ?? "nil") as String)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditDataAlternatif", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditDataAlternatif" {
            
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedDataAlternatif = dataAlternatifArray[indexPath.row]
            let navController = segue.destination as! UINavigationController
            let destinationVC = navController.topViewController as! TambahEditDataAlternatifTableViewController
            destinationVC.titleNavigasi = "Ubah"
            destinationVC.selectedKecamatan = selectedKecamatan
            destinationVC.selectedDataAlternatif = selectedDataAlternatif
        
        }
    }
    
    //MARK: Data Manipulation Methods
    
    func loadDataAlternatifs(with request: NSFetchRequest<DataAlternatifs> = DataAlternatifs.fetchRequest()) {
        
        let predicate = NSPredicate(format: "namaKecamatannya.namaDaerah MATCHES %@", selectedKecamatan!.namaDaerah!)
        
        request.predicate = predicate
        
        do {
            dataAlternatifArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func saveDataAlternatifs() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: -Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Hapus Alternatif", message: "Yakin untuk menghapus?", preferredStyle: UIAlertController.Style.alert)
                      
                      alert.addAction(UIAlertAction(title: "Batal", style: UIAlertAction.Style.default, handler: { _ in
                          //batal hapus
                      }))
                      
                      alert.addAction(UIAlertAction(title: "Hapus", style: UIAlertAction.Style.default, handler: { (_ : UIAlertAction!) in
                        self.context.delete(self.dataAlternatifArray[indexPath.row])
                        self.dataAlternatifArray.remove(at: indexPath.row) //menghapus melalui array sekarang
                        self.saveDataAlternatifs() //menghapus di persistent data
                      }))
                      
                       self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    
    @IBAction func unwindToDataAlternatifTable(segue: UIStoryboardSegue) {
        guard  segue.identifier == "saveUnwind" else { return }
        
        let sourceViewController = segue.source as! TambahEditDataAlternatifTableViewController
   
        if let selectedDataAlternatif = sourceViewController.selectedDataAlternatif {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                dataAlternatifArray[selectedIndexPath.row] = selectedDataAlternatif 
            }
        } else {
            
            
            let newDataAlternatif = DataAlternatifs(context: context)
            
            newDataAlternatif.namaKecamatannya = selectedKecamatan
            newDataAlternatif.namaParameternya = sourceViewController.selectedBobot
            newDataAlternatif.createdBy = userLoggedIn
            newDataAlternatif.createdAt = Date()
            newDataAlternatif.updatedAt = Date()
            newDataAlternatif.rangeNilainya = sourceViewController.selectedNilai
           

            dataAlternatifArray.append(newDataAlternatif)
            
        }
        
        saveDataAlternatifs()
        
    }
}
