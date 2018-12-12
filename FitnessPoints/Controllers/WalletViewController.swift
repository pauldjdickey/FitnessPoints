//
//  WalletViewController.swift
//  FitnessPoints
//
//  Created by Paul Dickey on 12/12/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//
import UIKit

class WalletViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //This is how many rows we will make
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //How many items are in our offers, 1 is a placeholder
    }
    
    //This is what will go into the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "walletOfferCell", for: indexPath)
        
        return cell
    }
    
    
}


