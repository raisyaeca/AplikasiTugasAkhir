//
//  TambahEditDataAlternatifTableViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 8/26/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit
import CoreData

class TambahEditDataAlternatifTableViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedDataAlternatif: DataAlternatifs?
    var listParameter = [BobotParameters]()
    var listNilaiKlasifikasi = [NilaiKlasifikasi]()
    var titleNavigasi = "Tambah"
   
    var DataAlternatif: DataAlternatifs?
    
    var maxParamKaliAlter: Float?
    
    var nilaiAlternatif: Float?
    var nilaiBobot: Float?
    var selectedKecamatan: Kecamatans?
    var selectedNilai: NilaiKlasifikasi?
    var selectedBobot: BobotParameters? {
        didSet {
            loadNilai()
        }
    }
    

    let bobotPicker = UIPickerView()
    let nilaiPicker = UIPickerView()


    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!
   
    @IBOutlet weak var rangeNilaiTextField: UITextField!
    @IBOutlet weak var bobotTextField: UITextField!
    @IBOutlet weak var nilaiAlternatifLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var kecamatanLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        navigationController?.applyDesign()
        
        navigationItem.title = "\(titleNavigasi) Data Alternatif \(selectedKecamatan?.namaDaerah ?? "")"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        

        bobotPicker.delegate = self
        bobotPicker.dataSource = self
        nilaiPicker.delegate = self
        nilaiPicker.dataSource = self
        

        rangeNilaiTextField.inputView = nilaiPicker
        bobotTextField.inputView = bobotPicker
        
        bobotTextField.text = selectedDataAlternatif?.namaParameternya?.namaParameter
        rangeNilaiTextField.text = selectedDataAlternatif?.rangeNilainya?.rangeNilaiParameter
        
        kecamatanLabel.text = selectedKecamatan?.namaDaerah
        

        if let selectedDataAlternatif = selectedDataAlternatif {
            
            createdAtLabel.text = (dateFormatter.string(from: selectedDataAlternatif.createdAt!))
            updatedAtLabel.text = (dateFormatter.string(from: selectedDataAlternatif.updatedAt!))
            createdByLabel.text = selectedDataAlternatif.createdBy?.username
            nilaiAlternatifLabel.text = NSString(format: "%.2f", selectedDataAlternatif.rangeNilainya!.nilai_klasifikasi) as String
            
        }
        
        loadBobotPicker()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
  
        selectedDataAlternatif?.namaParameternya = selectedBobot
        selectedDataAlternatif?.rangeNilainya = selectedNilai
        selectedDataAlternatif?.updatedAt = Date()
        
    }
    
    
    
    func loadBobotPicker(with request: NSFetchRequest<BobotParameters> = BobotParameters.fetchRequest()) {
        do {
            listParameter = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    
    func loadNilai(with request: NSFetchRequest<NilaiKlasifikasi> = NilaiKlasifikasi.fetchRequest()) {
        
        let predicate = NSPredicate(format: "namaParameternya.namaParameter MATCHES %@", selectedBobot!.namaParameter!)
        
        request.predicate = predicate
        do {
            listNilaiKlasifikasi = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        nilaiPicker.reloadAllComponents()
 
    }
}

extension TambahEditDataAlternatifTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == bobotPicker {
            return listParameter.count
           
        } else {
            return listNilaiKlasifikasi.count
          
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
      if pickerView == bobotPicker {
            return listParameter[row].namaParameter
            
        } else {
        
            return listNilaiKlasifikasi[row].rangeNilaiParameter

        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       let row = pickerView.selectedRow(inComponent: 0)
        if pickerView == bobotPicker {
            selectedBobot = listParameter[row]
            nilaiBobot = listParameter[row].nilaiBobotParameter
            bobotTextField.text = listParameter[row].namaParameter
          
        } else {
            
            selectedNilai = listNilaiKlasifikasi[row]
            nilaiAlternatif = listNilaiKlasifikasi[row].nilai_klasifikasi
            rangeNilaiTextField.text = listNilaiKlasifikasi[row].rangeNilaiParameter
            nilaiAlternatifLabel.text = NSString(format: "%.2f", listNilaiKlasifikasi[row].nilai_klasifikasi) as String

        }
    }
}

