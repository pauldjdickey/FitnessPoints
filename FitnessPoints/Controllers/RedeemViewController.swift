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
    let pointsDB = Database.database().reference().child("Users")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        fetchOffers()
    }
    
    func fetchOffers() {
        
        Database.database().reference().child("Offers").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                Database.database().reference().child("Offers").observe(.childAdded) { (redeemsnapshot) in
                    // Need to make this safe...
                    if let dictionary = redeemsnapshot.value as? [String: AnyObject] {
                        let offer = Offer()
                        offer.cost = dictionary["cost"] as? Int
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let offer = offers[indexPath.row]
        
        let redeemAlert = UIAlertController(title: "Redeem", message: "Are you sure you'd like to redeem '\(offer.title!)' for \(offer.cost!) points?", preferredStyle: UIAlertController.Style.alert)
        redeemAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
            print("Time to redeem!")
            self.pointsDB.child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    self.pointsDB.child(Auth.auth().currentUser!.uid).child("points").observeSingleEvent(of: .value, with: { (snapshot) in
                        let snapshotValue = snapshot.value as! Int
                        let points = snapshotValue
                        if points >= offer.cost! {
                            let EnoughToRedeemAlert = UIAlertController(title: "Congratulations!", message: "You have used \(offer.cost!) points to redeem this coupon! Check out your wallet to use it in store.", preferredStyle: UIAlertController.Style.alert)
                            EnoughToRedeemAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                            self.present(EnoughToRedeemAlert, animated: true, completion: nil)
                            let updatedPointsWithRedeem = points - offer.cost!
                            let pointsUpdatedWithRedeem = ["points": updatedPointsWithRedeem]
                            self.pointsDB.child(Auth.auth().currentUser!.uid).setValue(pointsUpdatedWithRedeem) {
                                (error, reference) in
                                
                                if error != nil {
                                    print(error!)
                                } else {
                                    print("Points saved successfully and offer added to wallet!")
                                    //THIS IS WHERE WE NEED TO SAVE THE OFFER TO OUR FIREBASE WALLET
                                    //Right now this is replacing our points value, for some reason, how do we fix that?
                                                                    self.pointsDB.child(Auth.auth().currentUser!.uid).child("offers").observeSingleEvent(of: .value, with: { (snapshotcheck) in
                                                                            if snapshotcheck.exists() {
                                                                                print("The snapshot for offers exists!")
                                                                                //This is where we will
                                                                            } else {
                                                                                //This saves the title to a snapshot called offers, even if there isn't an offer there. We need to next it though and continue to add to it...
                                                                                let currentOffer = offer.title
                                                                                let offers2 = ["offers": currentOffer]
                                                                                self.pointsDB.child(Auth.auth().currentUser!.uid).updateChildValues(offers2 as [AnyHashable : Any])
                                                                                
                                                                            }
                                                                        })
                                    
                                    
                                    
                                }
                            }
                        } else {
                            let notEnoughToRedeemAlert = UIAlertController(title: "Sorry", message: "You don't have enough points for this offer. Complete more workouts to get more points!", preferredStyle: UIAlertController.Style.alert)
                            notEnoughToRedeemAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                            self.present(notEnoughToRedeemAlert, animated: true, completion: nil)
                        }
                    })
                } else {
                    print("No user data to load")
                    let noPointsToRedeemAlert = UIAlertController(title: "Sorry", message: "You don't have any points. Complete a workout to get your first points.", preferredStyle: UIAlertController.Style.alert)
                    noPointsToRedeemAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                    self.present(noPointsToRedeemAlert, animated: true, completion: nil)
                }
            })
            
        }))
        redeemAlert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.destructive, handler: { action in
            print("Okay, cancel selection")
        }))
        self.present(redeemAlert, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

//        let redeemAlert = UIAlertController(title: "Redeem", message: "Are you sure you'd like to redeem 'Get 20% off your next MAX FIT order' for \(offer.cost!) points?", preferredStyle: UIAlertController.Style.alert)
//                redeemAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
//                    print("Time to redeem!")
//                    self.pointsDB.child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
//                        if snapshot.exists() {
//                            self.pointsDB.child(Auth.auth().currentUser!.uid).child("points").observeSingleEvent(of: .value, with: { (snapshot) in
//                                let snapshotValue = snapshot.value as! Int
//                                let points = snapshotValue
//                                print(points)
//                                if points >= 250 { // Add here
//                                    let EnoughToRedeemAlert = UIAlertController(title: "Congratulations!", message: "You have used 250 points to redeem your coupon! Check out your wallet to use it in store.", preferredStyle: UIAlertController.Style.alert)
//                                    EnoughToRedeemAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
//                                    self.present(EnoughToRedeemAlert, animated: true, completion: nil)
//                                    let updatedPointsWithRedeem = points - 250 // Add here
//                                    let pointsUpdatedWithRedeem = ["points": updatedPointsWithRedeem]
//                                    //var pointsSaved = Int(counter/2)

//                                    self.pointsDB.child(Auth.auth().currentUser!.uid).setValue(pointsUpdatedWithRedeem) {
//                                        (error, reference) in
//
//                                        if error != nil {
//                                            print(error!)
//                                        }
//                                        else {
//                                            print("Points saved successfully!")
//                                            //THIS IS WHERE WE NEED TO SAVE THE OFFER TO OUR FIREBASE WALLET
//                                            }
//                                        }
//                                    }
//
//                                } else {
//                                    let notEnoughToRedeemAlert = UIAlertController(title: "Sorry", message: "You don't have enough points for this offer. Complete more workouts to get more points!", preferredStyle: UIAlertController.Style.alert)
//                                    notEnoughToRedeemAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
//                                    self.present(notEnoughToRedeemAlert, animated: true, completion: nil)
//                                }
//                            }
//                            )} else {
//                            print("No user data to load")
//                            let noPointsToRedeemAlert = UIAlertController(title: "Sorry", message: "You don't have any points. Complete a workout to get your first points.", preferredStyle: UIAlertController.Style.alert)
//                            noPointsToRedeemAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
//                            self.present(noPointsToRedeemAlert, animated: true, completion: nil)
//                        }
//                    })
//                }))
//                redeemAlert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.destructive, handler: { action in
//                    print("Okay, cancel redeem.")
//                }))
//                self.present(redeemAlert, animated: true, completion: nil)
//                tableView.deselectRow(at: indexPath, animated: true)
