//
//  ViewController.swift
//  Arcade App Base
//
//  Created by Paul Dickey on 12/3/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import SVProgressHUD


class ViewController: UIViewController, CLLocationManagerDelegate, UIApplicationDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let locationsModel = LocationsModel()
    let pointsDB = Database.database().reference().child("Points")
    let locationManager = CLLocationManager()
    let currentDateTime = Date()
    var geofenceRegion = CLCircularRegion()
    var previousPoints:Int = 0
    var currentPoints:Int = 0
    var counter = 0.0
    var timer = Timer()
    var isPlaying = false
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var checkInLabel: UIButton!
    @IBOutlet weak var pointLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
        timeLabel.text = String(counter)
        pauseButton.isEnabled = false
        startButton.isHidden = true
        pauseButton.isHidden = true
        endButton.isHidden = true
        timeLabel.isHidden = true
        NotificationCenter.default.addObserver(self, selector:#selector(upDateTimeDifference), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        //This loads data from firebase upon load
        //Need to make it if we cant connect to the internet, but are logged in, we access saved data on our plist
        
        pointsDB.child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                self.pointsDB.child(Auth.auth().currentUser!.uid).child("points").observe(.value) { (snapshot) in
                    let snapshotValue = snapshot.value as! Int
                    let points = snapshotValue
                    print("PRINTED POINTS UPON LOAD: \(points)")
                    self.pointLabel.text = ("\(points)")
                    self.previousPoints = Int(points)
                }
            } else {
            print("No user data to load")
            }
    })
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        navigationController?.setNavigationBarHidden(false, animated: false)
//    }
    @IBAction func checkInButton(_ sender: UIButton) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        counter = 0.0
    }
    @IBAction func startTimer(_ sender: Any) {
        if(isPlaying) {
            return
        }
        startButton.isEnabled = false
        pauseButton.isEnabled = true
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        isPlaying = true
    }
    @IBAction func pauseTimer(_ sender: Any) {
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        timer.invalidate()
        isPlaying = false
        print(appDelegate.arriveTime - appDelegate.leaveTime)
    }
    @IBAction func resetTimer(_ sender: Any) {
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        timer.invalidate()
        isPlaying = false
        if counter == 0.0 {
        } else if counter < 2.0 {
            let alert2 = UIAlertController(title: "Ooops!", message: "Make sure you workout longer to get points.", preferredStyle: UIAlertController.Style.alert)
            alert2.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert2, animated: true, completion: nil)
        } else {
            let alert3 = UIAlertController(title: "Congratulations!", message: "You earned \(Int(counter/2)) points", preferredStyle: UIAlertController.Style.alert)
            alert3.addAction(UIAlertAction(title: "End Workout", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert3, animated: true, completion: nil)
        }
        print(counter)
        //pointLabel.text = ("\(previousPoints + Int(counter/2))")
        currentPoints = previousPoints + Int(counter/2)
        print("YOUR CURRENT POINTS ARE: \(currentPoints)")
        let points = ["points": currentPoints]
        
        var pointsSaved = Int(counter/2)
        //This will be where we write to our plist
        print ("Points Save Test = \(pointsSaved)")
        pointsDB.child(Auth.auth().currentUser!.uid).setValue(points) {
            (error, reference) in
            
            if error != nil {
                print(error!)
            }
            else {
                print("Points saved successfully!")
                pointsSaved = 0
                // This will be where we override our plist IF successfully saved
                print("Points Save Test w/ successful save = \(pointsSaved)")
            }
        }
        
        pointLabel.text = ("\(currentPoints)")
        previousPoints += Int(counter/2)
        counter = 0.0
        timeLabel.text = String(counter)
        startButton.isHidden = true
        pauseButton.isHidden = true
        endButton.isHidden = true
        timeLabel.isHidden = true
        checkInLabel.isHidden = false
        self.locationManager.stopMonitoring(for: geofenceRegion)
        print("User has ended the workout, and the monitor for geofence has stopped")
    }
    @objc func UpdateTimer() {
        counter = counter + 0.1
        timeLabel.text = String(format: "%.1f", counter)
        if appDelegate.userLeftRegion == true {
            timer.invalidate()
            isPlaying = false
            startButton.isEnabled = false
            pauseButton.isEnabled = false
            //appDelegate.userLeftRegion = false
            // This code checks every second the timer is running and stops the timer if the user leaves the region. Only works when the user is actively using the app.
        }
    }
    @objc func upDateTimeDifference() {
        print("User Loaded Back")
        if isPlaying == true {
            print("Timer is running and now updated")
        counter = counter + appDelegate.timeDifference
        } else if isPlaying == false && appDelegate.userLeftRegion == true {
            counter = counter + appDelegate.timeDifferenceLeftRegion
            timeLabel.text = String(format: "%.1f", counter)
            //appDelegate.timeDifferenceLeftRegion = 0.0
            appDelegate.userLeftRegion = false
            print("Time is stopped because user left area, and is now updated")
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { // This is the method that gets activated once the location manager has found a GPS coordinate // This saves the location into an array called [CLLocation] // This will create a bunch of locations, but the last value is the one that we want, as its most accurate for the user
        let location = locations[locations.count - 1] // This will find the last location put into the array
        
        if location.horizontalAccuracy > 0 { // This indicates that the lattitude and longitude is valid
            locationManager.stopUpdatingLocation() // This will then stop the GPS from looking, so it doesnt drain battery
            locationManager.delegate = nil // This will only bring back the 1 GPS coordinate, which means it only requests 1 GPS coordinate
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            //let check = locationsModel.canWeWorkout(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let check = locationsModel.canWeWorkout(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let savedLatitude = location.coordinate.latitude
            let savedLongitude = location.coordinate.longitude
            //Use this one when testing on computer.
            print(check)
            
            if check == true {
                let geofenceRegionCenter = CLLocationCoordinate2D(
                    latitude: savedLatitude,
                    longitude: savedLongitude
                    // This sets up our geofence and will not change until workout is complete.
                    // If we are ready to start a workout, it creates a geofence based on the current location (Have to put location.coordinate.latitude/longitude in)
                )
                /* Create a region centered on desired location,
                 choose a radius for the region (in meters)
                 choose a unique identifier for that region */
                    geofenceRegion = CLCircularRegion(
                    center: geofenceRegionCenter,
                    radius: 50,
                    identifier: "UniqueIdentifier"
                )
                // This creates the parameters for our geolocation w/ an identifier (We can add 20 geofences)
                //geofenceRegion.notifyOnEntry = true
                geofenceRegion.notifyOnExit = true
                // This will only notify us or do something when we have left
                self.locationManager.startMonitoring(for: geofenceRegion)
                print("Monitoring for geolocation with center \(location.coordinate.latitude) \(location.coordinate.longitude) has started")
                print("Lets do it!")
                startButton.isHidden = false
                pauseButton.isHidden = false
                endButton.isHidden = false
                timeLabel.isHidden = false
                checkInLabel.isHidden = true
                
            } else {
                print("Gotta go to a gym first")
                let alert = UIAlertController(title: "Can't Start Workout", message: "You must be at a valid gym to check in and begin your workout.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    }


