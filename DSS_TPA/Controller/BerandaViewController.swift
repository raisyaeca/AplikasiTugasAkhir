//
//  BerandaViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 7/1/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit
import CoreData

class BerandaViewController: UIViewController {
    
    var userRoleLoggedIn = ""
    var usernameLoggedIn = ""
    var userLoggings = [Users]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var dataPenggunaButton: UIButton!
    @IBOutlet weak var dataPengujianButton: UIButton!
    @IBOutlet weak var dataSMARTButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataPenggunaButton.applyButtonDesign()
        dataPengujianButton.applyButtonDesign()
        dataSMARTButton.applyButtonDesign()
        
        self.navigationItem.title = "Beranda"
        let navController = self.tabBarController?.viewControllers![2] as! UINavigationController
        let destinationVC = navController.topViewController as! ProfileTableViewController
        destinationVC.usernameLoggedIn = usernameLoggedIn
        destinationVC.userRoleLoggedIn = userRoleLoggedIn
        
        dataSMARTButton.titleLabel?.numberOfLines = 0
        dataSMARTButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        dataPengujianButton.titleLabel?.numberOfLines = 0
        dataPengujianButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        if userRoleLoggedIn != "Admin"  {
            dataPenggunaButton.isHidden = true
        }
        
        load()
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Beranda"
        self.navigationController?.topViewController?.title = "Beranda"
 
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let userYangMasuk = userLoggings[0]
        
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "DataTPAMenu":
            
            let navController = segue.destination as! UINavigationController
            let destinationVC = navController.topViewController as! MenuDataTPATableViewController
            destinationVC.userLoggedIn = userYangMasuk

        case "DataUsers":
        let navController = segue.destination as! UINavigationController
        let destinationVC = navController.topViewController as! UserDataTableViewController
            destinationVC.userLoggedIn = userYangMasuk
            
        default:
            break
        }
    }
    
    func load() {
        
        let request = NSFetchRequest<Users>(entityName: "Users")
        request.predicate = NSPredicate(format: "username == %@", usernameLoggedIn)
        do {
            userLoggings = try context.fetch(request)
        } catch {
            print(error)
        }
        
    }
    
    @IBAction func unwindToBeranda(segue: UIStoryboardSegue) {
        
    }
    

}
