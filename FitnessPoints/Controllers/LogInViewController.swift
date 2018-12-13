//
//  LogInViewController.swift
//  FitnessPoints
//
//  Created by Paul Dickey on 12/7/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {
    
    //Textfields pre-linked with IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func logInPressed(_ sender: UIButton) {
        if self.passwordTextField.hasText == false || self.emailTextField.hasText == false {
            return
        } else {
            SVProgressHUD.show()
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error != nil {
                    print(error!)
                    SVProgressHUD.dismiss()
                    let logInAlert = UIAlertController(title: "Ooops!", message: "Your email and/or password does not match our records.", preferredStyle: UIAlertController.Style.alert)
                    logInAlert.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default, handler: nil))
                    self.present(logInAlert, animated: true, completion: nil)
                } else {
                    print("Log in successful!")
                    
                    SVProgressHUD.dismiss()
                    
                    self.performSegue(withIdentifier: "goToApp", sender: self)
                    let backItem = UIBarButtonItem()
                    backItem.title = "Logout"
                    self.navigationItem.backBarButtonItem = backItem
                    
                }
                
            }
        }
    }
    
}
