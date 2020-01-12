//
//  TambahEditNilaiKlasifikasiTableViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 8/26/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit
import CoreData

class TambahEditNilaiKlasifikasiTableViewController: UITableViewController {
    
    var selectedNilaiKlasifikasi: NilaiKlasifikasi?
    var selectedBobotParameter: BobotParameters?
    var titleNavigasi = "Tambah"
   


    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var rangeNilaiParameterTextField: UITextField!
    @IBOutlet weak var nilaiKlasifikasiTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        navigationItem.title = "\(titleNavigasi) Klasifikasi \(selectedNilaiKlasifikasi?.rangeNilaiParameter ?? "")"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
      
        rangeNilaiParameterTextField.text = selectedNilaiKlasifikasi?.rangeNilaiParameter
    
        if let selectedNilaiKlafisikasi = selectedNilaiKlasifikasi {
            createdAtLabel.text = (dateFormatter.string(from: selectedNilaiKlafisikasi.createdAt!))
            updatedAtLabel.text = (dateFormatter.string(from: selectedNilaiKlafisikasi.updatedAt!))
            createdByLabel.text = selectedNilaiKlafisikasi.createdBy?.username
            nilaiKlasifikasiTextField.text = NSString(format: "%.2f", selectedNilaiKlafisikasi.nilai_klasifikasi) as String
            
        }
        
        updateSaveButtonState()
        navigationController?.applyDesign()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        selectedNilaiKlasifikasi?.rangeNilaiParameter = rangeNilaiParameterTextField.text ?? ""
        selectedNilaiKlasifikasi?.nilai_klasifikasi = (nilaiKlasifikasiTextField.text! as NSString).floatValue
        selectedNilaiKlasifikasi?.updatedAt = Date()


    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
        
    }
    
    func updateSaveButtonState() {
        let rangeNilaiParameter = rangeNilaiParameterTextField.text ?? ""
        let nilaiKlasifikasi = nilaiKlasifikasiTextField.text ?? ""
      
        saveButton.isEnabled = !rangeNilaiParameter.isEmpty && !nilaiKlasifikasi.isEmpty
    }
    
}

