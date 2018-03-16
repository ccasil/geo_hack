//
//  ViewController.swift
//  geo_hack
//
//  Created by Johnnie Tran on 3/15/18.
//  Copyright © 2018 Johnnie Tran. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1
        let location = CLLocationCoordinate2D(latitude: 37.3754, longitude: -121.910158)
        
        // 2
        let span = MKCoordinateSpanMake(0.001, 0.001)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        //3
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Coding Dojo"
        annotation.subtitle = "Silicon Valley"
        mapView.addAnnotation(annotation)


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

