//
//  RedeemViewController.swift
//  FitnessPoints
//
//  Created by Paul Dickey on 12/12/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import UIKit
import Firebase

class RedeemViewController: UITableViewController {
    
    
    var offers = [Offer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        fetchOffers()
    }
    
    func fetchOffers() {
        Database.database().reference().child("Offers").observe(.childAdded) { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let offer = Offer()
                offer.cost = dictionary["cost"] as? Int
                offer.title = dictionary["title"] as? String
                self.offers.append(offer)
                
                self.tableView.reloadData()
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return offers.count
        
    }
    
    //This is what will go into the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "redeemOfferCell", for: indexPath)
        
        let offer = offers[indexPath.row]
        cell.textLabel?.text = offer.title
        if offer.cost != nil {
            cell.detailTextLabel?.text = ("This offer costs \(offer.cost!) points to redeem")
        } else {
            cell.detailTextLabel?.text = "This offer does not have a cost"
        }
        
        
        return cell
    }

//    //This is how many rows we will make
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return locations.count //How many items are in our offers, 1 is a placeholder
//    }
//
//    //This is what will go into the cells
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "redeemOfferCell", for: indexPath)
//
//        cell.textLabel?.text = locations[indexPath.row]
//
//        return cell
//    }
    
    // What happens when we select a certain cell
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let redeemAlert = UIAlertController(title: "Redeem", message: "Are you sure you'd like to redeem 'Get 20% off your next MAX FIT order' for 250 points?", preferredStyle: UIAlertController.Style.alert)
//        redeemAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
//            print("Time to redeem!")
//            self.pointsDB.child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
//                if snapshot.exists() {
//                    self.pointsDB.child(Auth.auth().currentUser!.uid).child("points").observeSingleEvent(of: .value, with: { (snapshot) in
//                        let snapshotValue = snapshot.value as! Int
//                        let points = snapshotValue
//                        print(points)
//                        if points >= 250 {
//                            let EnoughToRedeemAlert = UIAlertController(title: "Congratulations!", message: "You have used 250 points to redeem your coupon! Check out your wallet to use it in store.", preferredStyle: UIAlertController.Style.alert)
//                            EnoughToRedeemAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
//                            self.present(EnoughToRedeemAlert, animated: true, completion: nil)
//                            let updatedPointsWithRedeem = points - 250
//                            let pointsUpdatedWithRedeem = ["points": updatedPointsWithRedeem]
//                            //var pointsSaved = Int(counter/2)
//                            self.pointsDB.child(Auth.auth().currentUser!.uid).setValue(pointsUpdatedWithRedeem) {
//                                (error, reference) in
//
//                                if error != nil {
//                                    print(error!)
//                                }
//                                else {
//                                    print("Points saved successfully!")
//                                    //THIS IS WHERE WE NEED TO SAVE THE OFFER TO OUR FIREBASE WALLET
//                                    self.walletOffers.append(self.locations[indexPath.row])
//                                    for element in self.walletOffers {
//                                        print("Offers in wallet are: \(element)", terminator: " ")
//                                    }
//                                }
//                            }
//
//                        } else {
//                            let notEnoughToRedeemAlert = UIAlertController(title: "Sorry", message: "You don't have enough points for this offer. Complete more workouts to get more points!", preferredStyle: UIAlertController.Style.alert)
//                            notEnoughToRedeemAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
//                            self.present(notEnoughToRedeemAlert, animated: true, completion: nil)
//                        }
//                    }
//                    )} else {
//                    print("No user data to load")
//                    let noPointsToRedeemAlert = UIAlertController(title: "Sorry", message: "You don't have any points. Complete a workout to get your first points.", preferredStyle: UIAlertController.Style.alert)
//                    noPointsToRedeemAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
//                    self.present(noPointsToRedeemAlert, animated: true, completion: nil)
//                }
//            })
//        }))
//        redeemAlert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.destructive, handler: { action in
//            print("Okay, cancel redeem.")
//        }))
//        self.present(redeemAlert, animated: true, completion: nil)
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
}