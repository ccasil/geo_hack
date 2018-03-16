//
//  ViewController.swift
//  geo_hack
//
//  Created by Johnnie Tran on 3/15/18.
//  Copyright © 2018 Johnnie Tran. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate{
    var atDojo = false
    let locationManager = CLLocationManager()
    let dojoLocation = CLLocation(latitude: 37.37554100, longitude: -121.91009960)
    let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 37.37554100, longitude: -121.91009960), radius: 20.0, identifier: "Dojo")
    var enterTime = Date()
    var exitTime = Date()
    var timeSpent = Int32(0)
    var user: [User] = []
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()


        func enableBasicLocationServices() {
            locationManager.delegate = self
            
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                // Request when-in-use authorization initially
                locationManager.requestWhenInUseAuthorization()
                print("request")
                break
                
            case .restricted, .denied:
                // Disable location features
//                disableMyLocationBasedFeatures()
                break
                
            case .authorizedWhenInUse, .authorizedAlways:
                print("authorized")
                // Enable location features
//                enableMyWhenInUseFeatures()
                break
            }
        }
        enableBasicLocationServices()
        
        func checkForLocationServices() {
            if CLLocationManager.locationServicesEnabled() {
                print("Location services enable")
            } else {
                print("Location services disabled")
            }
        }
        
        checkForLocationServices()
        locationManager.startUpdatingLocation()
        if(fetchAllItems() < 1){
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: managedObjectContext) as! User
            newUser.timeSpent = Int32(0)
            newUser.dateStart = Date()
            user.append(newUser)
        }
        
    }
        // Do any additional setup after loading the view, typically from a nib.
    
//    @IBAction func getLocation(_ sender: UIButton) {
//        print(locationManager.location)
//
//    }
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        print("enter")
//    }
//
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        print("exit ====================")
//    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if region.contains(locations[locations.count-1].coordinate) {
            print("You are at the dojo")
        }
        if(locations[locations.count-1].distance(from: dojoLocation) > 25){
            if(atDojo){
                atDojo = false
                exitTime = Date()
                user[0].timeSpent += Int32(Date().timeIntervalSince(enterTime))

            }
        }
        if(locations[locations.count-1].distance(from: dojoLocation) < 25){
            if(!atDojo){
                atDojo = true
                enterTime = Date()
            }
        }
        print(user[0].timeSpent, " total time spent")
        print(Int32(Date().timeIntervalSince(user[0].dateStart!)), " time since first started")
        print(atDojo, " are you at the dojo")
        print(Int32(Date().timeIntervalSince(enterTime)), " current visit duration")
    }
    

    func fetchAllItems() -> Int{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let result = try managedObjectContext.fetch(request)
            user = result as! [User]
            return user.count
        } catch
        {
            print("\(error)")

        }
        return -1
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

