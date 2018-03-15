//
//  ViewController.swift
//  geo_hack
//
//  Created by Johnnie Tran on 3/15/18.
//  Copyright © 2018 Johnnie Tran. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
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
        
    }
        // Do any additional setup after loading the view, typically from a nib.
    
    @IBAction func getLocation(_ sender: UIButton) {
        print(locationManager.location)

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations[locations.count-1])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

