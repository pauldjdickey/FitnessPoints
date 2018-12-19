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
                        offer.uuid = dictionary["uuid"] as? String
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
        cell.detailTextLabel?.text = "Tap to use offer"
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let offer = offers[indexPath.row]
        let useOfferAlert = UIAlertController(title: "Use your offer", message: "Are you sure you'd like to use your offer '\(offer.title!)'? Make sure you are in the location to use it.", preferredStyle: UIAlertController.Style.alert)
        useOfferAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
            print("Present confirmation")
            let confirmUseOfferAlert = UIAlertController(title: "USE OFFER", message: "Clicking 'USE OFFER' will use your coupon '\(offer.title!)'", preferredStyle: UIAlertController.Style.actionSheet)
            confirmUseOfferAlert.addAction(UIAlertAction(title: "USE OFFER", style: UIAlertAction.Style.destructive, handler: { action in
              print("Delete the current selection")
               print(offer.uuid!)
                Database.database().reference().child("Redeemed").child(Auth.auth().currentUser!.uid).child("\(offer.uuid!)").removeValue() {
                    (error:Error?, ref:DatabaseReference) in
                    if let error = error {
                        print("Data could not be saved: \(error).")
                    } else {
                        print("Data saved successfully!")
                        self.offers.remove(at: indexPath.row) // step 2
                        self.tableView.deleteRows(at: [indexPath], with: .fade) // step 3
                        tableView.reloadData()
                    }
                }
            }))
            confirmUseOfferAlert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(confirmUseOfferAlert, animated: true, completion: nil)
        }))
        useOfferAlert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.destructive, handler: { action in
            print("Okay, cancel selection")
        }))
        self.present(useOfferAlert, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
