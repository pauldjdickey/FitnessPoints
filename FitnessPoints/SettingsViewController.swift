//
//  SettingsViewController.swift
//  FitnessPoints
//
//  Created by Paul Dickey on 12/10/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch {
            print("error: there was a problem logging out")
        }
    }
    
}
