//
//  LocationsModel.swift
//  Arcade App Base
//
//  Created by Paul Dickey on 12/3/18.
//  Copyright © 2018 Paul Dickey. All rights reserved.
//

import UIKit
import CoreLocation

class LocationsModel {
    
    func canWeWorkout(latitude: Double, longitude: Double) -> Bool {
        
        let fromLocation:CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        var places:[Places] = [
            
            Places( title: "Alec",
                    cllocation: CLLocation( latitude :36.6157, longitude: -121.8285), regionRadius: 150.0, location: "Alec",
                    type: "Gym",distance : CLLocation( latitude :36.6157,
                                                        longitude: -121.8285).distance(from: fromLocation),
                    coordinate : CLLocationCoordinate2DMake(36.6157,-121.8285)),
            
            Places( title: "Paul",
                    cllocation: CLLocation(latitude:36.6651,longitude:-121.8039), regionRadius:150.0, location:"Paul",
                    type: "Gym",distance : CLLocation(latitude:36.6651,
                                                       longitude:-121.8039).distance(from: fromLocation),
                    coordinate : CLLocationCoordinate2DMake(36.6651,-121.8039)),
            Places( title: "StarbucksMarina",
                    cllocation: CLLocation(latitude:36.6658,longitude:-121.8099), regionRadius:150.0, location:"StarbucksMarina",
                    type: "Gym",distance : CLLocation(latitude:36.6658,
                                                      longitude:-121.8099).distance(from: fromLocation),
                    coordinate : CLLocationCoordinate2DMake(36.6658,-121.8099)),
            Places( title: "StarbucksSalinas",
                    cllocation: CLLocation(latitude:36.6706,longitude:-121.6414), regionRadius:150.0, location:"StarbucksSalinas",
                    type: "Gym",distance : CLLocation(latitude:36.6706,
                                                      longitude:-121.6414).distance(from: fromLocation),
                    coordinate : CLLocationCoordinate2DMake(36.6706,-121.6414)),
            Places( title: "Courthouse",
                    cllocation: CLLocation(latitude:36.6748,longitude:-121.6585), regionRadius:150.0, location:"Courhouse",
                    type: "Gym",distance : CLLocation(latitude:36.6748,
                                                      longitude:-121.6585).distance(from: fromLocation),
                    coordinate : CLLocationCoordinate2DMake(36.6748,-121.6585)),
            Places( title: "Skyler",
                    cllocation: CLLocation(latitude:36.6161,longitude:-121.8361), regionRadius:150.0, location:"Skyler",
                    type: "Gym",distance : CLLocation(latitude:36.6161,
                                                      longitude:-121.8361).distance(from: fromLocation),
                    coordinate : CLLocationCoordinate2DMake(36.6161,-121.8361)),
            Places( title: "CSUMB",
                    cllocation: CLLocation(latitude:36.6545,longitude:-121.8084), regionRadius:150.0, location:"CSUMB",
                    type: "Gym",distance : CLLocation(latitude:36.6545,
                                                      longitude:-121.8084).distance(from: fromLocation),
                    coordinate : CLLocationCoordinate2DMake(36.6545,-121.8084)),
            Places( title: "Anytime Fitness Marina",
                    cllocation: CLLocation(latitude:36.6654,longitude:-121.8109), regionRadius:150.0, location:"Anytime Fitness Marina",
                    type: "Gym",distance : CLLocation(latitude:36.6654,
                                                      longitude:-121.8109).distance(from: fromLocation),
                    coordinate : CLLocationCoordinate2DMake(36.6654,-121.8109)),
            Places( title: "In Shape Seaside",
                    cllocation: CLLocation(latitude:36.5968,longitude:-121.8537), regionRadius:150.0, location:"In Shape Seaside",
                    type: "Gym",distance : CLLocation(latitude:36.5968,
                                                      longitude:-121.8537).distance(from: fromLocation),
                    coordinate : CLLocationCoordinate2DMake(36.5968,-121.8537)),
            Places( title: "Crossfit Monterey",
                    cllocation: CLLocation(latitude:36.6015,longitude:-121.8653), regionRadius:150.0, location:"Crossfit Monterey",
                    type: "Gym",distance : CLLocation(latitude:36.6015,
                                                      longitude:-121.8653).distance(from: fromLocation),
                    coordinate : CLLocationCoordinate2DMake(36.6015,-121.8653)),
            Places( title: "First City Crossfit",
                    cllocation: CLLocation(latitude:36.5851,longitude:-121.8504), regionRadius:150.0, location:"First City Crossfit",
                    type: "Gym",distance : CLLocation(latitude:36.5851,
                                                      longitude:-121.8504).distance(from: fromLocation),
                    coordinate : CLLocationCoordinate2DMake(36.5851,-121.8504)),
            Places( title: "Starbucks Sand City",
                    cllocation: CLLocation(latitude:36.6223,longitude:-121.8442), regionRadius:150.0, location:"Starbucks Sand City",
                    type: "Gym",distance : CLLocation(latitude:36.6223,
                                                      longitude:-121.8442).distance(from: fromLocation),
                    coordinate : CLLocationCoordinate2DMake(36.6223,-121.8442)),
            Places( title: "MaxFit - Monterey",
                    cllocation: CLLocation(latitude:36.5949,longitude:-121.8904), regionRadius:150.0, location:"MaxFit - Monterey",
                    type: "Gym",distance : CLLocation(latitude:36.5949,
                                                      longitude:-121.8904).distance(from: fromLocation),
                    coordinate : CLLocationCoordinate2DMake(36.5949,-121.8904)),
        ]
        
        //Before sort the array
            for k in 0...(places.count-1) {
                print("\(places[k].distance!)")
        }
        //sort the array based on the current location to calculate the distance to compare the each and every array objects to sort the values
        for place in places {
            place.calculateDistance(fromLocation: fromLocation) // Replace YOUR_LOCATION with the location you want to calculate the distance to.
        }
        
        for k in 0...(places.count-1) {
        if places[k].distance! > 50 {
            print("Distance too far \(places[k].distance!)")
        } else {
            print("Distance close enough \(places[k].distance!)")
            return true
        }
        }
        return false
    }
}
