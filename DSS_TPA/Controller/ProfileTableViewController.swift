//
//  ProfileTableViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 10/21/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit
import ChameleonFramework

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var keluarButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    
    var userRoleLoggedIn = ""
    var usernameLoggedIn = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.keluarButton.isHidden = false
        
        self.usernameLabel.text = usernameLoggedIn
        self.roleLabel.text = userRoleLoggedIn
        navigationController?.applyDesign()
        
        
    }

}
