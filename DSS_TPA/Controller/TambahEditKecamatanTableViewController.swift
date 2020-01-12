//
//  TambahEditKecamatanTableViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 9/6/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit

class TambahEditKecamatanTableViewController: UITableViewController {

    var selectedKecamatan: Kecamatans?
    var titleNavigasi = "Tambah"
    
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var kecamatanTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        navigationItem.title = "\(titleNavigasi) Kecamatan"
        navigationController?.applyDesign()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector((UIView.endEditing)))
        view.addGestureRecognizer(tap)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        kecamatanTextField.text = selectedKecamatan?.namaDaerah
      
    
        if let selectedKecamatan = selectedKecamatan {
            createdAtLabel.text = (dateFormatter.string(from: selectedKecamatan.createdAt!))
            updatedAtLabel.text = (dateFormatter.string(from: selectedKecamatan.updatedAt!))
            createdByLabel.text = selectedKecamatan.createdBy?.username
          
        }
        
        updateSaveButtonState()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else { return }
        
        selectedKecamatan?.namaDaerah = kecamatanTextField.text ?? ""
        selectedKecamatan?.updatedAt = Date()
        
        
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
        let namaDaerah = kecamatanTextField.text ?? ""
      
        saveButton.isEnabled = !namaDaerah.isEmpty
    }
}
