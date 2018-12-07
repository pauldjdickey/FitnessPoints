//
//  WelcomeViewController.swift
//  FitnessPoints
//
//  Created by Paul Dickey on 12/7/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import UIKit
import Firebase


class WelcomeViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //If there is a logged in user, by pass this screen and go straight to ChatViewController
        
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "goToApp", sender: self)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
