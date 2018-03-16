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
import MapKit
import AVFoundation

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var currentStatusLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var totalInLabel: UILabel!
    @IBOutlet weak var totalOutLabel: UILabel!
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()

    var atDojo = false
    let dojoLocation = CLLocation(latitude: 37.37554100, longitude: -121.91009960)
    let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 37.37554100, longitude: -121.91009960), radius: 10.0, identifier: "Dojo")
    var enterTime = Date()
    var exitTime = Date()

    var user: [User] = []
    var timeSpent = Int32(0)
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

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
        if(fetchAllItems() < 1){
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: managedObjectContext) as! User
            newUser.timeSpent = Int32(0)
            newUser.dateStart = Date()
            user.append(newUser)
        }
        timeSpent = user[0].timeSpent
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
                self.myUtterance = AVSpeechUtterance(string: "See you later")
                self.myUtterance.rate = 0.4
                self.synth.speak(self.myUtterance)
                
                do {
                    try managedObjectContext.save()
                } catch {
                    print ("\(error)")
                }
            }
        }
        if(locations[locations.count-1].distance(from: dojoLocation) < 25){
            if(!atDojo){
                atDojo = true
                enterTime = Date()
                self.myUtterance = AVSpeechUtterance(string: "Happy Coding")
                self.myUtterance.rate = 0.4
                self.synth.speak(self.myUtterance)
            }
        }
        print(locations[locations.count-1].distance(from: dojoLocation))
        var duration = Int32(0)
        if enterTime > exitTime{
            duration = Int32(Date().timeIntervalSince(enterTime))
        }
        if(atDojo){
            currentStatusLabel.text = "Happy Coding!"
            currentStatusLabel.textColor = UIColor.green
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
            dateFormatter.locale = Locale(identifier: "en_US")
            let timeEnter = dateFormatter.string(from: enterTime)
            startLabel.text = "Start: \(timeEnter)"
        } else {
            currentStatusLabel.text = "Slacker!"
            currentStatusLabel.textColor = UIColor.red
            startLabel.text = "You are not at the Dojo"
        }
        
        let durationMin = Int(floor(Double(duration / 60)))
        let durationSec = duration % 60
        durationLabel.text = "Duration: \(durationMin) mins and \(durationSec) secs"
        
        let totalin = Int32(user[0].timeSpent + duration)
        let totalInMin = Int(floor(Double(totalin / 60)))
        let totalInSec = totalin % 60
        totalInLabel.text = "Total In: \(totalInMin) mins and \(totalInSec) secs"
        
        let totalout = Int32(Date().timeIntervalSince(user[0].dateStart!)) - totalin
        let totalOutMin = Int(floor(Double(totalout / 60)))
        let totalOutSec = totalout % 60
        totalOutLabel.text = "Total Out: \(totalOutMin) mins and \(totalOutSec) secs"
        
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
        } catch {
            print("\(error)")
        }
        return -1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

