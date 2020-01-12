//
//  TambahEditbobotTableViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 8/26/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit

class TambahEditbobotTableViewController: UITableViewController {
    
    var selectedBobot: BobotParameters?
    var titleNavigasi = "Tambah"
    

    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var namaParameterTextField: UITextField!
    @IBOutlet weak var nilaiBobotTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        
        navigationItem.title = "\(titleNavigasi) Parameter"
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector((UIView.endEditing)))
        
        view.addGestureRecognizer(tap)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        namaParameterTextField.text = selectedBobot?.namaParameter
        

        if let selectedBobot = selectedBobot {
            createdAtLabel.text = (dateFormatter.string(from: selectedBobot.createdAt!))
            updatedAtLabel.text = (dateFormatter.string(from: selectedBobot.updatedAt!))
            createdByLabel.text = selectedBobot.createdBy?.username
            nilaiBobotTextField.text = NSString(format: "%.2f", selectedBobot.nilaiBobotParameter) as String
        }
        
        updateSaveButtonState()
        navigationController?.applyDesign()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else { return }
        
        
        selectedBobot?.namaParameter = namaParameterTextField.text ?? ""
        selectedBobot?.nilaiBobotParameter = (nilaiBobotTextField.text! as NSString).floatValue
//        selectedBobot?.nilaiRelatifBobot = ((nilaiBobotTextField.text! as NSString).floatValue / 100.00)
        selectedBobot?.updatedAt = Date()
        
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
        let namaParameter = namaParameterTextField.text ?? ""
        let nilaiBobot = nilaiBobotTextField.text ?? ""
        saveButton.isEnabled = !namaParameter.isEmpty && !nilaiBobot.isEmpty
    }
}
