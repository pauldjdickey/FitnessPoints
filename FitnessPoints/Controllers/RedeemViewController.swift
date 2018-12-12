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
    
    var locations = [String]()
    var walletOffers = [String]()
    var pointsToRedeem = 250
    let pointsDB = Database.database().reference().child("Users")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        locations = ["MAX FIT - Get 20% off your next order"]
    }
    //This is how many rows we will make
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count //How many items are in our offers, 1 is a placeholder
    }
    
    //This is what will go into the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "redeemOfferCell", for: indexPath)
        
        cell.textLabel?.text = locations[indexPath.row]
        
        return cell
    }
    
    // What happens when we select a certain cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let redeemAlert = UIAlertController(title: "Redeem", message: "Are you sure you'd like to redeem 'Get 20% off your next MAX FIT order' for 250 points?", preferredStyle: UIAlertController.Style.alert)
        redeemAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
            print("Time to redeem!")
            self.pointsDB.child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                    self.pointsDB.child(Auth.auth().currentUser!.uid).child("points").observeSingleEvent(of: .value, with: { (snapshot) in
                        let snapshotValue = snapshot.value as! Int
                        let points = snapshotValue
                        print(points)
                        if points >= 250 {
                            let EnoughToRedeemAlert = UIAlertController(title: "Congratulations!", message: "You have used 250 points to redeem your coupon! Check out your wallet to use it in store.", preferredStyle: UIAlertController.Style.alert)
                            EnoughToRedeemAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                            self.present(EnoughToRedeemAlert, animated: true, completion: nil)
                            let updatedPointsWithRedeem = points - 250
                            let pointsUpdatedWithRedeem = ["points": updatedPointsWithRedeem]
                            //var pointsSaved = Int(counter/2)
                            self.pointsDB.child(Auth.auth().currentUser!.uid).setValue(pointsUpdatedWithRedeem) {
                                (error, reference) in
                                
                                if error != nil {
                                    print(error!)
                                }
                                else {
                                    print("Points saved successfully!")
                                    //THIS IS WHERE WE NEED TO SAVE THE OFFER TO OUR FIREBASE WALLET
                                    self.walletOffers.append(self.locations[indexPath.row])
                                    for element in self.walletOffers {
                                        print("Offers in wallet are: \(element)", terminator: " ")
                                    }
                                }
                            }
                        
                        } else {
                            let notEnoughToRedeemAlert = UIAlertController(title: "Sorry", message: "You don't have enough points for this offer. Complete more workouts to get more points!", preferredStyle: UIAlertController.Style.alert)
                            notEnoughToRedeemAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                            self.present(notEnoughToRedeemAlert, animated: true, completion: nil)
                        }
                    }
                )} else {
                    print("No user data to load")
                    let noPointsToRedeemAlert = UIAlertController(title: "Sorry", message: "You don't have any points. Complete a workout to get your first points.", preferredStyle: UIAlertController.Style.alert)
                    noPointsToRedeemAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                    self.present(noPointsToRedeemAlert, animated: true, completion: nil)
                }
            })
        }))
        redeemAlert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.destructive, handler: { action in
            print("Okay, cancel redeem.")
        }))
        self.present(redeemAlert, animated: true, completion: nil)
    }
    
    
    
    
    func retrieveOffers() {
        
        let offersDB = Database.database().reference().child("Messages")
        
        offersDB.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,Int>
           // let location = snapshotValue["MessageBody"]!
            //let pointsToRedeem = snapshotValue["Sender"]!
            
//            let message = Message()
//            message.messageBody = text
//            message.sender = sender
//
//            self.messageArray.append(message)
//
//
//            self.configureTableView()
//            self.messageTableView.reloadData()
            
            
            
        }
        
    }
}
