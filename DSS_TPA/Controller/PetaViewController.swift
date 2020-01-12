//
//  PetaViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 10/20/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit
import WebKit

class PetaViewController: UIViewController, WKNavigationDelegate {
    
    var userRoleLoggedIn = ""
    var usernameLoggedIn = ""
   
    @IBOutlet weak var webView: WKWebView!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationItem.title = "Peta"
            
            let url = URL(string: "https://raisyanasution.carto.com/builder/9855f8c4-1435-4b13-847b-f0dba6520001/embed")
            
            let request = URLRequest(url: url!)
            webView.load(request)
            navigationController?.applyDesign()


        }

    
}
