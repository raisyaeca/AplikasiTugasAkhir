//
//  MenuDataTPATableViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 9/6/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit

class MenuDataTPATableViewController: UITableViewController {
    
    var userLoggedIn: Users?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        navigationController?.popToRootViewController(animated: true);
        self.navigationItem.title = "Data Pengujian"
        navigationController?.applyDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
           navBar.prefersLargeTitles = true
           navigationItem.largeTitleDisplayMode = .always
           
       }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let  identifier = segue.identifier else { return }
        
        switch identifier {
        
        case "DataKabupaten":
        let destinationVC = segue.destination as! DataKabupatenTableViewController
            destinationVC.userLoggedIn = userLoggedIn
        case "DataKabKec":
            let destinationVC = segue.destination as! KabKecTableViewController
            destinationVC.userLoggedIn = userLoggedIn
        case "BobotParameter":
            let destinationVC = segue.destination as! TabelBobotTableViewController
            destinationVC.userLoggedIn = userLoggedIn
        case "KumpulanBobotKeKlasifikasi":
             let destinationVC = segue.destination as! KumpulanBobotKeKlasifikasiTableViewController
             destinationVC.userLoggedIn = userLoggedIn
        case "goToKumpulanDataByKabupaten":
            let destinationVC = segue.destination as! KabDatAlterTableViewController
            destinationVC.userLoggedIn = userLoggedIn
        default:
            break
        }
        
       
    }

   
}
