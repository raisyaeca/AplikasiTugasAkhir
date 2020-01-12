//
//  UndipViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 11/5/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit

class UndipViewController: UIViewController {

    @IBOutlet weak var berikutnyaButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        berikutnyaButton.applyButtonDesign()
    }
}

extension UIButton {
    func applyButtonDesign() {
        self.layer.cornerRadius = 30
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
    }
}
