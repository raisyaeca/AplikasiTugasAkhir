//
//  DataSMARTTableViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 9/6/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit
import CoreData

class DataSMARTTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedKabupaten: Kabupaten?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 90.0
        navigationController?.applyDesign()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let  identifier = segue.identifier else { return }
        
        
        switch identifier {
        case "BobotRelatif":
            print("Go to Bobot Relatif")
        case "AlterKaliParam":
            let destinationVC = segue.destination as! KecKeAlterKaliParamTableViewController
            destinationVC.selectedButton = "AlterKaliParam"
            destinationVC.selectedKabupaten = selectedKabupaten
        case "FaktorEvaluasi":
            let destinationVC = segue.destination as! KecKeAlterKaliParamTableViewController
            destinationVC.selectedButton = "FaktorEvaluasi"
            destinationVC.selectedKabupaten = selectedKabupaten
        case "BobotEvaluasi":
            let destinationVC = segue.destination as! KecKeAlterKaliParamTableViewController
            destinationVC.selectedButton = "BobotEvaluasi"
            destinationVC.selectedKabupaten = selectedKabupaten
        case "goToRanking":
            let destinationVC = segue.destination as! RankingTableViewController
            destinationVC.selectedKabupaten = selectedKabupaten
        default:
            break
        }
        
    }
    
    

}








