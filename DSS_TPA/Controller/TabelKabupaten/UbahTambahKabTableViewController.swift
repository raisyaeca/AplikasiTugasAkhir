//
//  UbahTambahKabTableViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 11/4/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit

class UbahTambahKabTableViewController: UITableViewController {
    
    var selectedKabupaten: Kabupaten?
    var titleNavigasi = "Tambah"
    
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var updatedAt: UILabel!
    @IBOutlet weak var createdBy: UILabel!
    @IBOutlet weak var kabupatenTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
            navigationItem.title = "\(titleNavigasi) Kabupaten"
        navigationController?.applyDesign()
            
            let tap = UITapGestureRecognizer(target: self.view, action: #selector((UIView.endEditing)))
            view.addGestureRecognizer(tap)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
            
        kabupatenTextField.text = selectedKabupaten?.namaKabupaten
          
        
            if let selectedKabupaten = selectedKabupaten {
                createdAt.text = (dateFormatter.string(from: selectedKabupaten.createdAt!))
                updatedAt.text = (dateFormatter.string(from: selectedKabupaten.updatedAt!))
                createdBy.text = selectedKabupaten.createdBy?.username
              
            }
            
            updateSaveButtonState()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else { return }
        
        selectedKabupaten?.namaKabupaten = kabupatenTextField.text ?? ""
        selectedKabupaten?.updatedAt = Date()
        
        
    }
    
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
           let namaDaerah = kabupatenTextField.text ?? ""
         
           saveButton.isEnabled = !namaDaerah.isEmpty
       }
    
    
}
