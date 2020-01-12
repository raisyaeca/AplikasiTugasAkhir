//
//  MasukViewController.swift
//  DSS_TPA
//
//  Created by Raisya Nasution on 7/1/19.
//  Copyright © 2019 Raisya Nasution. All rights reserved.
//

import UIKit
import CoreData

class MasukViewController: UIViewController, UIApplicationDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var masukButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var userArray = [Users]()
    var userRoleLoggedIn = ""
    var usernameLoggedIn = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        masukButton.layer.cornerRadius = 25
        masukButton.layer.borderWidth = 1
        masukButton.layer.borderColor = UIColor.white.cgColor
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector((UIView.endEditing)))
        
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToBeranda" {
            let nav = segue.destination as! UINavigationController
            let tabCtrl = nav.topViewController as! UITabBarController
            let destinationVC = tabCtrl.viewControllers![0] as! BerandaViewController
            destinationVC.userRoleLoggedIn = userRoleLoggedIn
            destinationVC.usernameLoggedIn = usernameLoggedIn
        }
                    self.usernameTextField.text = ""
                    self.passwordTextField.text = ""
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    @IBAction func masukButton(_ sender: Any) {
       let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        let searchString = self.usernameTextField.text
        let searchString2 = self.passwordTextField.text
        let t = "admin"
        let d = "admin"
        
        request.predicate = NSPredicate (format: "username == %@", searchString!)
        
        if (searchString == t && searchString2 == d) {
            
            userRoleLoggedIn = "Admin"
            usernameLoggedIn = "admin"
            
            performSegue(withIdentifier: "goToBeranda", sender: self)
            
        } else {
        do{
            let result = try context.fetch(request)
            if result.count > 0
            {
                let n = (result[0] as AnyObject).value(forKey: "username") as! String
                let p = (result[0] as AnyObject).value(forKey: "password") as! String
          
                if (searchString == n && searchString2 == p)
                {
                    userRoleLoggedIn = (result[0] as AnyObject).value(forKey: "role") as! String
                    usernameLoggedIn = (result[0] as AnyObject).value(forKey: "username") as! String
                    
                    performSegue(withIdentifier: "goToBeranda", sender: self)
                }
                
                else if (searchString == n || searchString2 == p)
                {
                  print("no user found")
                }
            
            else {
                  print("invalid username")
                }
                
        }
        }
            catch {
                print("error")
            }
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }

}
