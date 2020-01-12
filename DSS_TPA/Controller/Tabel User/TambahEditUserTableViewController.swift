//
//  TambahEditUserTableViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 8/14/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit

class TambahEditUserTableViewController: UITableViewController {

 
    var selectedUser: Users?
    var titleNavigasi = "Tambah"
   
    
    let tglLahirPickerCellIndexPath = IndexPath(row: 3, section: 1)
    let rolePickerCellIndexPath = IndexPath(row: 2, section: 2)
    
    var isTglLahirPickerShown: Bool =  false {
        didSet {
            tglLahirDatePicker.isHidden = !isTglLahirPickerShown
        }
    }
    
    var isRolePickerShown: Bool = false {
        didSet {
            rolePickerView.isHidden = !isRolePickerShown
        }
    }
    
    var rolePickerData: [String] = [String]()
    
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var rolePickerView: UIPickerView!
    @IBOutlet weak var tglLahirLabel: UILabel!
    @IBOutlet weak var tglLahirDatePicker: UIDatePicker!
    @IBOutlet weak var namaTextField: UITextField!
    @IBOutlet weak var alamatTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.applyDesign()
        navigationItem.title = "\(titleNavigasi) Pengguna"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        rolePickerView.delegate = self
        rolePickerView.dataSource = self
        
        rolePickerData = ["Admin", "Client", "Manager"]
        
        namaTextField.text = selectedUser?.name
        alamatTextField.text = selectedUser?.alamat
        usernameTextField.text = selectedUser?.username
        passwordTextField.text = selectedUser?.password
        if let selectedUser = selectedUser {
            tglLahirDatePicker.date = selectedUser.tanggal_lahir!
            createdAtLabel.text = (dateFormatter.string(from: selectedUser.created_at!))
            updatedAtLabel.text = (dateFormatter.string(from: selectedUser.updated_at!))
        }
        roleLabel.text = selectedUser?.role ?? "Admin"
        
        updateSaveButtonState()
        updateDateViews()

        }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        selectedUser?.name = namaTextField.text ?? ""
        selectedUser?.alamat = alamatTextField.text ?? ""
        selectedUser?.username = usernameTextField.text ?? ""
        selectedUser?.password = passwordTextField.text ?? ""
        selectedUser?.tanggal_lahir = tglLahirDatePicker.date
        selectedUser?.role = roleLabel.text ?? "Admin"
        selectedUser?.updated_at = Date()
        
        }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (tglLahirPickerCellIndexPath.section, tglLahirPickerCellIndexPath.row):
            if isTglLahirPickerShown {
                return 216.0
            } else {
                return 0.0
            }
        case (rolePickerCellIndexPath.section, rolePickerCellIndexPath.row):
            if isRolePickerShown {
                return 216.0
            } else {
                return 0.0
            }
        default:
            return 44.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (tglLahirPickerCellIndexPath.section, tglLahirPickerCellIndexPath.row - 1):
            
            if isTglLahirPickerShown {
                isTglLahirPickerShown = false
            } else if isRolePickerShown {
                isRolePickerShown = false
                isTglLahirPickerShown = true
            } else {
                isTglLahirPickerShown = true
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
        
        case (rolePickerCellIndexPath.section, rolePickerCellIndexPath.row - 1):
            
            if isRolePickerShown {
                isRolePickerShown = false
            } else if isRolePickerShown {
                isTglLahirPickerShown = false
                isRolePickerShown = true
            } else {
                isRolePickerShown = true
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        default:
            break
        }
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
        
    }
    
 
    func updateSaveButtonState() {
        let usernameText = usernameTextField.text ?? ""
        let alamatText = alamatTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        let namaText = namaTextField.text ?? ""
        saveButton.isEnabled = !usernameText.isEmpty && !alamatText.isEmpty && !passwordText.isEmpty && !namaText.isEmpty
    }
    
    func updateDateViews() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        tglLahirLabel.text = dateFormatter.string(from: tglLahirDatePicker.date)
    }
    


    }

extension TambahEditUserTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rolePickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rolePickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        roleLabel.text = rolePickerData[row]
    }
 
}
    

