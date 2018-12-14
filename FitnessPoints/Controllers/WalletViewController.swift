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
    
    var walletOffers = [Wallet]()
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWalletOffers()
    }
    //
    func fetchWalletOffers() {
        //This is working
        Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("offers").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                // this is not working
                Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("offers").observe(.childAdded, with: { (walletsnapshot) in
                    // I need to create each MAXFIT offer in my user DB as a snapshot, then see the details from each snapshot to populate the cells!
                    if let dictionary = walletsnapshot.value as? [String: AnyObject] {
                        let wallet = Wallet()
                        wallet.title = dictionary["title"] as? String
                        self.walletOffers.append(wallet)
                        self.tableView.reloadData()
                    }
                })
            } else {
                print("No wallet data to load")
            }
        })
    }
    //
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("The amount of offers is \(walletOffers.count)")
        return walletOffers.count
    }
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "walletCell", for: indexPath)
        
        let walletOffer = walletOffers[indexPath.row]
        cell.textLabel?.text = walletOffer.title
        return cell
    
}


}
