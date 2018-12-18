//
//  WalletViewController.swift
//  FitnessPoints
//
//  Created by Paul Dickey on 12/12/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//
import UIKit
import Firebase

class WalletViewController: UITableViewController {
    
    var offers = [Offer]()
    let pointsDB = Database.database().reference().child("Users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchOffers()
    }
    //
    func fetchOffers() {
        
        Database.database().reference().child("Redeemed").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                Database.database().reference().child("Redeemed").child(Auth.auth().currentUser!.uid).observe(.childAdded) { (redeemsnapshot) in
                    // Need to make this safe...
                    if let dictionary = redeemsnapshot.value as? [String: AnyObject] {
                        let offer = Offer()
                        //offer.cost = dictionary["cost"] as? Int
                        offer.title = dictionary["title"] as? String
                        self.offers.append(offer)
                        self.tableView.reloadData()
                    }
                }
            } else {
                print("No redeemable coupons")
            }
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return offers.count
        
    }
    
    //This is what will go into the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "walletCell", for: indexPath)
        
        let offer = offers[indexPath.row]
        cell.textLabel?.text = offer.title
        if offer.cost != nil {
            cell.detailTextLabel?.text = ("Tap to redeem for \(offer.cost!) points.")
        } else {
            cell.detailTextLabel?.text = "Tap to redeem"
        }
        
        
        
        return cell
    }


}
