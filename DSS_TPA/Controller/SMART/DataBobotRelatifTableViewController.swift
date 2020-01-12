//
//  DataBobotRelatifTableViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 9/7/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit
import CoreData


class DataBobotRelatifTableViewController: UITableViewController {
    
    
    var bobotRelatifArray = [BobotParameters]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 90.0
        loadBobotRelatif()
        tableView.allowsSelection = false
        navigationController?.applyDesign()
    }
    
//     MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bobotRelatifArray.count

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "DataBobotRelatifCell", for: indexPath)
        
        let bobotRelatif = bobotRelatifArray[indexPath.row]
        let totalBobot = totalNilaiBobot()
        let nilaiBobotRelatif = (bobotRelatif.nilaiBobotParameter / totalBobot)
        
        cell.textLabel?.text = bobotRelatif.namaParameter
        cell.detailTextLabel?.text = NSString(format: "%.2f", nilaiBobotRelatif) as String
      
        return cell
    }
    
    //  MARK: - Data Manipulation Method
    
    func saveDataAlternatifs() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadBobotRelatif(with request: NSFetchRequest<BobotParameters> = BobotParameters.fetchRequest()) {
        
                do {
                    bobotRelatifArray = try context.fetch(request)
                } catch {
                    print("Error fetching data from context \(error)")
                }
        
        tableView.reloadData()
    }
    
    //SUM Nilai Bobot
    
    func totalNilaiBobot() -> Float {
        
        var totalBobot: Float = 0
        
        let sumExpressionDescription = NSExpressionDescription()
        sumExpressionDescription.name = "totalNilaiBobot"
        sumExpressionDescription.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: "nilaiBobotParameter")])
        sumExpressionDescription.expressionResultType = .floatAttributeType
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BobotParameters")
        
        request.propertiesToFetch = [sumExpressionDescription]
        request.resultType = .dictionaryResultType
        
        do {
            let results = try context.fetch(request)
            let resultMap = results[0] as! [String:Float]
            totalBobot = resultMap["totalNilaiBobot"]!
        } catch let error as NSError {
            NSLog("Error when summing amounts: \(error.localizedDescription)")
        }
        
        return totalBobot
        
    }
    
}

