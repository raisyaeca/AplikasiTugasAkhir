//
//  UserDataTableViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 7/8/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit
import CoreData


class UserDataTableViewController: SwipeTableViewController {

    var userArray = [Users]()
    var userLoggedIn: Users?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(userLoggedIn)

        tableView.rowHeight = 80.0
        loadUsers()
        navigationController?.applyDesign()
       
    }
   
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        return userArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let user = userArray[indexPath.row]
        
        cell.textLabel?.text = user.username
        cell.detailTextLabel?.text = user.role
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditUser", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditUser" {
            
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedUser = userArray[indexPath.row]
            let navController = segue.destination as! UINavigationController
            let destinationVC = navController.topViewController as! TambahEditUserTableViewController
            destinationVC.titleNavigasi = "Ubah"
            destinationVC.selectedUser = selectedUser
        }
    }
    //MARK: Data Manipulation Methods
    
    func loadUsers(with request: NSFetchRequest<Users> = Users.fetchRequest()) {
    
        do {
            userArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    func saveUser() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
        
    }
    
  
    
    //MARK: -Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if userLoggedIn?.username == userArray[indexPath.row].username {
            
            let alert = UIAlertController(title: "Tidak Dapat Menghupus User", message: "User adalah anda sendiri", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                //batal hapus
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
        
        let alert = UIAlertController(title: "Hapus User", message: "Yakin untuk menghapus?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Batal", style: UIAlertAction.Style.default, handler: { _ in
            //batal hapus
        }))
        
        alert.addAction(UIAlertAction(title: "Hapus", style: UIAlertAction.Style.default, handler: { (_ : UIAlertAction!) in
                self.context.delete(self.userArray[indexPath.row]) //menghapus di persistent data
                self.userArray.remove(at: indexPath.row) //menghapus melalui array sekarang
                self.saveUser()
        }))
        
         self.present(alert, animated: true, completion: nil)
            
        }
        
    }

   @IBAction func unwindToUserDataTable(segue:UIStoryboardSegue) {
    guard  segue.identifier == "saveUnwind" else { return }
    
    let sourceViewController = segue.source as! TambahEditUserTableViewController
    
    let dateFormatter = DateFormatter()
    
    dateFormatter.timeStyle = .medium
    
    if let selectedUser = sourceViewController.selectedUser {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            
            userArray[selectedIndexPath.row] = selectedUser
            
        }
        
    } else {
        
        let newUser = Users(context: context)
        newUser.username = sourceViewController.usernameTextField.text
        newUser.alamat = sourceViewController.alamatTextField.text
        newUser.password = sourceViewController.passwordTextField.text
        newUser.name = sourceViewController.namaTextField.text
        newUser.created_at = Date()
        newUser.updated_at = Date()
        newUser.tanggal_lahir = sourceViewController.tglLahirDatePicker.date
        newUser.role = sourceViewController.roleLabel.text
        userArray.append(newUser)
        
    }
    
     saveUser()
     loadUsers()

    }
    
}

//MARK: - Search Bar Methods

extension UserDataTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Users> = Users.fetchRequest()
        
        request.predicate = NSPredicate(format: "username CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "username", ascending: true)]
        
        loadUsers(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadUsers()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

extension UINavigationController {
    func applyDesign() {
        self.navigationBar.barTintColor = UIColor(red: 92.0/255.0, green: 154.0/255.0, blue: 79.0/255.0, alpha: 0.0)
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "SFProRounded-Medium", size: 17.0) ?? UIFont.systemFont(ofSize: 17.0)]
        self.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "SFProRounded-Bold", size: 30.0) ?? UIFont.systemFont(ofSize: 30.0)]
      
    }
}
