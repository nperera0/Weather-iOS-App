//
//  WeatherViewController.swift
//  Weather
//
//  Created by Nisal Perera on 2015-11-09.
//  Copyright © 2015 BrainStation. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift
import CoreLocation

class WeatherViewController: UITableViewController, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager?
    var latitude = 0.0
    var longitude = 0.0
    
    var currentWeather: CurrentWeather? {
        get {
            let realm = try! Realm()
            let curWeather = realm.objects(CurrentWeather)
            return curWeather.first
        }
    }
    var dayWeather : Results<DayWeather> {
        get {
            let realm = try! Realm()
            let dayWeathers = realm.objects(DayWeather)
            return dayWeathers.sorted("date", ascending:true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        getWeather()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func requestLocationUpdates(){
       
        // Step 1. Make sure we haven't been denied access
        switch CLLocationManager.authorizationStatus(){
        case . Denied:
            fallthrough
        case .Restricted:
            return
        default:
            break
        }
        
        // Step 1.1 Make sure we haven't done all this already
        if locationManager != nil {
                return
        }
        
        locationManager = CLLocationManager()
        
        // Step 2. Request permission for location (if we haven't already)
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager?.requestAlwaysAuthorization()
        }
        
        // Step 3. Subscribe to location updates (if we haven't already)
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // Make sure the location changed by a significant amount
            if abs(location.coordinate.latitude - latitude) < 0.1 &&
                abs(location.coordinate.longitude - longitude) < 0.1 {
                    return
            }
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            print("Location: \(latitude),\(longitude)")
            getWeather()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
    }
    
    func getWeather() {
        // This function returns immediately: The request happens on a
        // background thread, and then it calls the completionHandler closure
        // you pass in.
        Alamofire.request(.GET, "https://api.forecast.io/forecast/e0ad861e183017092cec7fb188c2d787/\(latitude),-\(longitude)").response {
            (request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void in
            print("Request completed!")
            if let data = data {
                // Interpret data (which is NSData) as a JSON object
                let json = JSON(data: data)
                
                //Clear the existing objects in the databse 
                let realm = try! Realm()
                try! realm.write {
                    realm.deleteAll()
                }
                
                
                
                // Create a CurrentWeather instance from the JSON
                let current = CurrentWeather.fromJSON(json["currently"])
                try! realm.write {
                    realm.add(current)
                }
                
                //self.currentWeather = current
                
                let dailyData = json["daily"]["data"].array
                if let daily = dailyData?.map(DayWeather.fromJSON) {
                    // Copy over the weather data to our dayWeather property
                    
                    //self.dayWeather = daily
                
                    try! realm.write {
                        realm.add(daily)
                    }
                    
                    for day in daily {
                        print("Day \(day.date): \(day.summary)")
                    }
                    // Make sure we refresh the table view on the main thread
                    // or bad things will happen
                    dispatch_async(dispatch_get_main_queue()) { 
                        self.tableView.reloadData()
                    }
                }
                
                print("Current condition: \(current.date) \(current.summary) \(current.temperature)°F")
            }
        }
        print("Sent request")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of row
        if (section == 0)
        {
            return 1
        }
        else{
            return dayWeather.count;
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("currentWeatherCell", forIndexPath: indexPath) as! CurrentWeatherCell
            
            // Configure the cell...
            cell.weather = currentWeather
            
            return cell
        }
        
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("dayWeatherCell", forIndexPath: indexPath) as! DayWeatherCell
            
            // Configure the cell...
            cell.weather = dayWeather[indexPath.row]
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            // Set this to the height of the "current weather" prototype cell
            return 240.0
        }
        else {
            // Set this to the height of the "daily weather" prototype cell
            return 44.0
        }
    }
    
    // MARK: - Storyboard Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // I am going to a navigation controller
        if let nav = segue.destinationViewController as? UINavigationController {
            // withlocation view controller visible on top
        if let locationController = nav.topViewController as? LocationViewController {
                locationController.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
      }
    }
    

}
