//
//  TabelNilaiKlasifikasiTableViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 8/26/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit
import CoreData

class TabelNilaiKlasifikasiTableViewController: SwipeTableViewController {
    
    
    @IBOutlet weak var tambahButton: UIBarButtonItem!
    
    var nilaiKlasifikasiArray = [NilaiKlasifikasi]()
    var userLoggedIn: Users?
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedBobot: BobotParameters? {
        didSet {
            loadNilaiKlasifikasis()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Klasifikasi Parameter \(selectedBobot?.namaParameter ?? "")"

        if userLoggedIn?.role == "Client" {
            
        tableView.allowsSelection = false
        navigationItem.rightBarButtonItem = nil
                  
        }
       
    }
    
    //MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nilaiKlasifikasiArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if userLoggedIn?.role == "Client" {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        }
        let nilaiKlasifikasi = nilaiKlasifikasiArray[indexPath.row]
        
        
        cell.textLabel?.text = nilaiKlasifikasi.rangeNilaiParameter
        cell.detailTextLabel?.text = NSString(format: "%.2f", nilaiKlasifikasi.nilai_klasifikasi) as String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editNilaiKlasifikasi", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editNilaiKlasifikasi" {
            
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedNilaiKlasifikasi = nilaiKlasifikasiArray[indexPath.row]
            let navController = segue.destination as! UINavigationController
            let destinationVC = navController.topViewController as! TambahEditNilaiKlasifikasiTableViewController
            destinationVC.titleNavigasi = "Ubah"
            destinationVC.selectedNilaiKlasifikasi = selectedNilaiKlasifikasi
    
            
        }
    }
    
    //MARK: Data Manipulation Methods
    
    func loadNilaiKlasifikasis(with request: NSFetchRequest<NilaiKlasifikasi> = NilaiKlasifikasi.fetchRequest()) {
        
        let predicate = NSPredicate(format: "namaParameternya.namaParameter MATCHES %@", selectedBobot!.namaParameter!)
        
        request.predicate = predicate
        
        do {
            nilaiKlasifikasiArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func saveNilaiKlasifikasi() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func deleteBanyakDataAlternatif(rangeNilainya: String) {
        let request : NSFetchRequest<DataAlternatifs> = DataAlternatifs.fetchRequest()
        
        request.predicate = NSPredicate(format: "rangeNilainya.rangeNilaiParameter MATCHES %@", rangeNilainya)
        
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
        
        let alert = UIAlertController(title: "Hapus Klasifikasi", message: "Yakin untuk menghapus?", preferredStyle: UIAlertController.Style.alert)
                      
                      alert.addAction(UIAlertAction(title: "Batal", style: UIAlertAction.Style.default, handler: { _ in
                          //batal hapus
                      }))
                      
                      alert.addAction(UIAlertAction(title: "Hapus", style: UIAlertAction.Style.default, handler: { (_ : UIAlertAction!) in
                        self.deleteBanyakDataAlternatif(rangeNilainya: self.nilaiKlasifikasiArray[indexPath.row].rangeNilaiParameter!)
                               self.context.delete(self.nilaiKlasifikasiArray[indexPath.row])
                               self.nilaiKlasifikasiArray.remove(at: indexPath.row) //menghapus melalui array sekarang
                        self.saveNilaiKlasifikasi() //menghapus di persistent data
                      }))
                      
                       self.present(alert, animated: true, completion: nil)
        
       
    }
    
    
    @IBAction func unwindToNilaiKlasifikasiTabel(segue: UIStoryboardSegue) {
        guard  segue.identifier == "saveUnwind" else { return }
        
        let sourceViewController = segue.source as! TambahEditNilaiKlasifikasiTableViewController
        
        if let selectedNilaiKlasifikasi = sourceViewController.selectedNilaiKlasifikasi {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                nilaiKlasifikasiArray[selectedIndexPath.row] = selectedNilaiKlasifikasi
                
                
            }
        } else {
            
            let newNilaiKlasifikasi = NilaiKlasifikasi(context: context)
            newNilaiKlasifikasi.namaParameternya = selectedBobot
            newNilaiKlasifikasi.createdBy = userLoggedIn
            newNilaiKlasifikasi.rangeNilaiParameter = sourceViewController.rangeNilaiParameterTextField.text
            newNilaiKlasifikasi.nilai_klasifikasi = sourceViewController.nilaiKlasifikasiTextField.text!.floatValue
            newNilaiKlasifikasi.createdAt = Date()
            newNilaiKlasifikasi.updatedAt = Date()
            nilaiKlasifikasiArray.append(newNilaiKlasifikasi)
            
        }
        
        saveNilaiKlasifikasi()
        
    }
    

}
