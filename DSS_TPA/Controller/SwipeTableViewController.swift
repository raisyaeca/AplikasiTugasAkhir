//
//  SwipeTableViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 10/26/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        navigationController?.applyDesign()

    }
    
    //TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
         guard orientation == .right else { return nil }

         let deleteAction = SwipeAction(style: .destructive, title: "Hapus") { action, indexPath in
            
            self.updateModel(at: indexPath)
             
         }

         // customize the action appearance
         deleteAction.image = UIImage(named: "delete-icon")

         return [deleteAction]
     }
    
    func updateModel(at indexPath: IndexPath) {
        
    }
     
}
